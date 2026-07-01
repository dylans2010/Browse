import SwiftUI
import WebKit

struct SettingsView: View {
    @Bindable var aiSettings: AISettings
    @State private var apiKey: String = ""
    @Environment(\.modelContext) private var modelContext
    let activeWebView: WKWebView?
    let profileId: UUID?

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
                            let savePanel = NSSavePanel()
                            savePanel.allowedContentTypes = [.json]
                            savePanel.canCreateDirectories = true
                            savePanel.isExtensionHidden = false
                            savePanel.title = "Export Browser Data"
                            savePanel.message = "Choose a destination for your exported data."
                            savePanel.nameFieldStringValue = "BrowseData.json"

                            if savePanel.runModal() == .OK {
                                if let destinationURL = savePanel.url {
                                    try? FileManager.default.copyItem(at: url, to: destinationURL)
                                }
                            }
                        }
                    }
                }
            }

            Section("Tools") {
                NavigationLink("Diagnostics") {
                    DiagnosticsView(viewModel: DiagnosticsViewModel(), webView: activeWebView)
                }
                NavigationLink("Profiles") {
                    ProfilesView()
                }
                NavigationLink("Privacy") {
                    PrivacyView()
                }
                NavigationLink("Security") {
                    SecurityView(webView: activeWebView)
                }
                NavigationLink("Themes") {
                    ThemesView(profileId: profileId)
                }
            }
        }
        .padding()
        .onAppear {
            apiKey = (try? KeychainManager.shared.retrieve(for: "OpenRouterAPIKey")) ?? ""
        }
    }
}
