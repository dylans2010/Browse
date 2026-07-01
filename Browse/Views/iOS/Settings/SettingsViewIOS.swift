import SwiftUI
import WebKit
import UIKit

struct SettingsViewIOS: View {
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
                            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootVC = scene.windows.first?.rootViewController {
                                rootVC.present(activityVC, animated: true)
                            }
                        }
                    }
                }
            }

            Section("Tools") {
                NavigationLink("Search") {
                    SearchViewIOS()
                }
                NavigationLink("Diagnostics") {
                    DiagnosticsViewIOS(viewModel: DiagnosticsViewModel(), webView: activeWebView)
                }
                NavigationLink("Profiles") {
                    ProfilesViewIOS()
                }
                NavigationLink("Privacy") {
                    PrivacyViewIOS()
                }
                NavigationLink("Security") {
                    SecurityViewIOS(webView: activeWebView)
                }
                NavigationLink("Themes") {
                    ThemesViewIOS(profileId: profileId)
                }
                NavigationLink("Sessions") {
                    SessionsViewIOS(viewModel: SessionViewModel(), profileId: profileId ?? UUID())
                }
                NavigationLink("Workspaces") {
                    WorkspaceListView(viewModel: WorkspaceViewModel(), profileId: profileId ?? UUID())
                }
                NavigationLink("Extensions") {
                    ExtensionManagerIOS(viewModel: ExtensionViewModel())
                }
                NavigationLink("Custom Sites") {
                    customSiteDestination
                }
            }
        }
        .padding()
        .onAppear {
            apiKey = (try? KeychainManager.shared.retrieve(for: "OpenRouterAPIKey")) ?? ""
        }
    }

    @ViewBuilder
    private var customSiteDestination: some View {
        if let host = activeWebView?.url?.host {
            let viewModel = CustomSiteViewModel()
            viewModel.loadConfig(for: host)
            CustomSiteEditorIOS(viewModel: viewModel)
        } else {
            ContentUnavailableView("No Active Site", systemImage: "doc.text.magnifyingglass", description: Text("Open a page to edit custom site settings."))
        }
    }
}
