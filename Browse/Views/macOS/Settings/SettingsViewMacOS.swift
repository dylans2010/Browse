#if os(macOS)
import SwiftUI
import AppKit

struct SettingsView: View {
    @Bindable var aiSettings: AISettings
    @State private var apiKey: String = ""
    @Environment(\.modelContext) private var modelContext

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

            Section("Data Portability") {
                Button("Export Browser Data") {
                    Task {
                        if let url = try? await DataPortabilityManager.shared.exportData() {
                            NSWorkspace.shared.activateFileViewerSelecting([url])
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            apiKey = (try? KeychainManager.shared.retrieve(for: "OpenRouterAPIKey")) ?? ""
        }
    }
}
#endif
