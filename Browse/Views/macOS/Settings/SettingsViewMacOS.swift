#if os(macOS)
import SwiftUI
import WebKit
import AppKit
import UniformTypeIdentifiers

// MARK: – Main Settings View (macOS)

struct SettingsViewMacOS: View {
    // MARK: – Bindings / State
    @Bindable var aiSettings: AISettings
    @State private var apiKey: String = ""
    @Environment(\.modelContext) private var modelContext
    
    // MARK: – Dependencies passed from the parent
    let activeWebView: WKWebView?
    let profileId: UUID?
    
    // MARK: – Body
    var body: some View {
        Form {
            generalSection
            aiConfigurationSection
            dataPortabilitySection
            toolsSection
        }
        .padding()
        .onAppear {
            // Load saved API key when the view appears
            apiKey = (try? KeychainManager.shared.retrieve(for: "OpenRouterAPIKey")) ?? ""
        }
    }
}

// MARK: – UI Sections (extracted for readability)

private extension SettingsViewMacOS {
    
    // General toggles
    var generalSection: some View {
        Section("General") {
            Toggle("Enable AI Features", isOn: $aiSettings.isAIEnabled)
            Toggle("Show AI Sidebar", isOn: $aiSettings.showAISidebar)
        }
    }
    
    // Model picker + API‑key handling
    var aiConfigurationSection: some View {
        Section("AI Configuration") {
            Picker("Preferred Model", selection: $aiSettings.preferredModel) {
                Text("GPT‑3.5 Turbo").tag("openai/gpt-3.5-turbo")
                Text("GPT‑4 Turbo").tag("openai/gpt-4-turbo")
                Text("Claude 3 Opus").tag("anthropic/claude-3-opus")
            }
            
            SecureField("OpenRouter API Key", text: $apiKey)
            Button("Save API Key") {
                try? KeychainManager.shared.save(apiKey, for: "OpenRouterAPIKey")
            }
        }
    }
    
    // Export‑data button
    var dataPortabilitySection: some View {
        Section("Data Portability") {
            Button("Export Browser Data") {
                Task {
                    await exportBrowserData()
                }
            }
        }
    }
    
    // Collection of tool navigation links
    var toolsSection: some View {
        Section("Tools") {
            NavigationLink("Search") {
                SearchViewMacOS()
            }
            NavigationLink("Diagnostics") {
                DiagnosticsViewMacOS(viewModel: DiagnosticsViewModel(),
                                     webView: activeWebView)
            }
            NavigationLink("Profiles") {
                ProfilesViewMacOS()
            }
            NavigationLink("Privacy") {
                PrivacyViewMacOS()
            }
            NavigationLink("Security") {
                SecurityViewMacOS(webView: activeWebView)
            }
            NavigationLink("Themes") {
                ThemesViewMacOS(profileId: profileId)
            }
            NavigationLink("Sessions") {
                SessionsViewMacOS(viewModel: SessionViewModel(),
                                 profileId: profileId ?? UUID())
            }
            NavigationLink("Workspaces") {
                WorkspaceListView(viewModel: WorkspaceViewModel(),
                                  profileId: profileId ?? UUID())
            }
            NavigationLink("Extensions") {
                ExtensionManagerMacOS(viewModel: ExtensionViewModel())
            }
            NavigationLink("Custom Sites") {
                customSiteDestination
            }
        }
    }
}

// MARK: – Helper Functions

private extension SettingsViewMacOS {
    /// Runs the export‑data workflow.
    func exportBrowserData() async {
        guard let url = try? await DataPortabilityManager.shared.exportData() else { return }
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.json]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Export Browser Data"
        savePanel.message = "Choose a destination for your exported data."
        savePanel.nameFieldStringValue = "BrowseData.json"
        
        if savePanel.runModal() == .OK,
           let destinationURL = savePanel.url {
            try? FileManager.default.copyItem(at: url, to: destinationURL)
        }
    }
}

// MARK: – Custom Site Destination (fixed)

private extension SettingsViewMacOS {
    /// The view that appears when the user taps “Custom Sites”.
    @ViewBuilder
    var customSiteDestination: some View {
        if let host = activeWebView?.url?.host {
            // The view‑model is owned by SwiftUI so we keep its state.
            CustomSiteDestinationView(host: host)
        } else {
            ContentUnavailableView(
                "No Active Site",
                systemImage: "doc.text.magnifyingglass",
                description: Text("Open a page to edit custom site settings.")
            )
        }
    }
}

// MARK: – Helper Sub‑view for Custom Site Editing

/// Wraps the editor and loads the site configuration once the view appears.
private struct CustomSiteDestinationView: View {
    @State private var viewModel = CustomSiteViewModel()
    let host: String
    
    var body: some View {
        CustomSiteEditorMacOS(viewModel: viewModel)
            .onAppear {
                viewModel.loadConfig(for: host)
            }
    }
}
#endif
