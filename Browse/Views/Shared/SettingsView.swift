import SwiftUI

struct SettingsView: View {
    @Bindable var aiSettings: AISettings
    @State private var apiKey: String = ""

    var body: some View {
        Form {
            Section("General") {
                Toggle("Enable AI Features", isOn: $aiSettings.isAIEnabled)
                Toggle("Show AI Sidebar", isOn: $aiSettings.showAISidebar)
            }

            Section("AI Configuration") {
                Picker("Preferred Model", selection: $aiSettings.preferredModel) {
                    Text("GPT-3.5 Turbo").tag("openai/gpt-3.5-turbo")
                    Text("GPT-4 Turbo").tag("openai/gpt-4-turbo")
                    Text("Claude 3 Opus").tag("anthropic/claude-3-opus")
                }

                SecureField("OpenRouter API Key", text: $apiKey)
                Button("Save API Key") {
                    try? KeychainManager.shared.save(apiKey, for: "OpenRouterAPIKey")
                }
            }
        }
        .padding()
        .onAppear {
            apiKey = (try? KeychainManager.shared.retrieve(for: "OpenRouterAPIKey")) ?? ""
        }
    }
}
