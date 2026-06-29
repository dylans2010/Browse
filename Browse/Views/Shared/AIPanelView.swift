import SwiftUI

struct AIPanelView: View {
    @Bindable var streamingManager: StreamingManager
    @Bindable var conversationManager: ConversationManager
    @Bindable var modelManager: ModelManager
    var aiService: AIService
    var activeTab: TabManager.Tab?

    @State private var inputText: String = ""

    var body: some View {
        VStack {
            HStack {
                Text(LocalizedStringKey("AI_ASSISTANT"))
                    .font(.headline)
                Spacer()
                Picker("Model", selection: $modelManager.selectedModel) {
                    ForEach(modelManager.availableModels, id: \.self) { model in
                        Text(model.components(separatedBy: "/").last ?? model).tag(model)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding([.horizontal, .top])

            if let tab = activeTab {
                HStack {
                    Button(action: { summarizePage(tab) }) {
                        Text(LocalizedStringKey("SUMMARIZE_PAGE"))
                    }
                    .buttonStyle(.bordered)
                    Button(action: { explainPage(tab) }) {
                        Text(LocalizedStringKey("EXPLAIN_PAGE"))
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(conversationManager.messages, id: \.content) { message in
                        MessageBubble(message: message)
                    }

                    if streamingManager.isStreaming {
                        HStack {
                            Text(streamingManager.currentResponse)
                                .padding(10)
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(12)
                            Spacer()
                        }
                    }
                }
                .padding()
            }

            Divider()

            HStack {
                TextField(LocalizedStringKey("ASK_AI"), text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { sendMessage() }

                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                }
                .disabled(inputText.isEmpty || streamingManager.isStreaming)
                .accessibilityLabel("Send message")
            }
            .padding()
        }
        .frame(minWidth: 300)
    }

    private func summarizePage(_ tab: TabManager.Tab) {
        Task {
            let content = try? await tab.webPage.getPageContent()
            let prompt = PromptBuilder.build(.summarizePage(content: content ?? ""))
            sendAIRequest(prompt)
        }
    }

    private func explainPage(_ tab: TabManager.Tab) {
        Task {
            let content = try? await tab.webPage.getPageContent()
            let prompt = PromptBuilder.build(.explainPage(content: content ?? ""))
            sendAIRequest(prompt)
        }
    }

    private func sendMessage() {
        let text = inputText
        guard !text.isEmpty else { return }
        inputText = ""
        sendAIRequest(text)
    }

    private func sendAIRequest(_ text: String) {
        conversationManager.addMessage(OpenRouterModels.Message(role: "user", content: text))
        streamingManager.reset()
        streamingManager.isStreaming = true

        Task {
            do {
                let stream = aiService.stream(model: modelManager.selectedModel, messages: conversationManager.messages)
                for try await chunk in stream {
                    streamingManager.append(chunk)
                }
                conversationManager.addMessage(OpenRouterModels.Message(role: "assistant", content: streamingManager.currentResponse))
                streamingManager.isStreaming = false
            } catch {
                print("AI Stream Error: \(error)")
                streamingManager.isStreaming = false
            }
        }
    }
}

struct MessageBubble: View {
    let message: OpenRouterModels.Message

    var body: some View {
        HStack {
            if message.role == "user" { Spacer() }

            Text(message.content)
                .padding(10)
                .background(message.role == "user" ? Color.blue : Color.secondary.opacity(0.2))
                .foregroundColor(message.role == "user" ? .white : .primary)
                .cornerRadius(12)

            if message.role != "user" { Spacer() }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(message.role == "user" ? "You" : "AI"): \(message.content)")
    }
}
