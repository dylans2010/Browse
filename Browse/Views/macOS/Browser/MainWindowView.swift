#if os(macOS)
import SwiftUI
import AppKit
import SwiftData

struct MainWindowView: View {
    @State private var tabManager = TabManager()
    @State private var streamingManager = StreamingManager()
    @State private var conversationManager = ConversationManager()
    @State private var modelManager = ModelManager()
    private let aiService = AIService.shared
    @State private var urlText: String = ""
    @State private var isShowingAISidebar: Bool = false
    @State private var isShowingCustomSiteEditor: Bool = false
    @State private var isReaderModeActive: Bool = false
    @Query private var profiles: [Profile]
    @State private var uiConfig: UIConfiguration?

    var body: some View {
        NavigationSplitView {
            if uiConfig?.useVerticalTabs ?? true {
                SidebarViewMacOS(tabManager: tabManager)
            } else {
                List {
                    Section("Navigation") {
                        NavigationLink(destination: BookmarkManagerView()) {
                            Label("Bookmarks", systemImage: "bookmark")
                        }
                        NavigationLink(destination: HistoryManagerView()) {
                            Label("History", systemImage: "clock")
                        }
                    }
                }
            }
        } detail: {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { tabManager.activeTab?.webPage.goBack() }) {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(!(tabManager.activeTab?.webPage.canGoBack ?? false))

                        Button(action: { tabManager.activeTab?.webPage.goForward() }) {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(!(tabManager.activeTab?.webPage.canGoForward ?? false))

                        AddressBarViewMacOS(
                            text: $urlText,
                            isLoading: tabManager.activeTab?.webPage.isLoading ?? false,
                            progress: tabManager.activeTab?.webPage.estimatedProgress ?? 0,
                            isReaderAvailable: tabManager.activeTab?.webPage.isReaderAvailable ?? false,
                            isReaderModeActive: $isReaderModeActive,
                            onCommit: { loadURL() },
                            onReload: { tabManager.activeTab?.webPage.reload() }
                        )

                        Button(action: { isShowingCustomSiteEditor.toggle() }) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(isShowingCustomSiteEditor ? .blue : .primary)
                        }
                        .help("Custom Sites Editor")

                        Button(action: { isShowingAISidebar.toggle() }) {
                            Image(systemName: "sparkles")
                                .foregroundColor(isShowingAISidebar ? .blue : .primary)
                        }

                        NavigationLink {
                            SettingsViewMacOS(aiSettings: AISettings(), activeWebView: tabManager.activeTab?.webPage.webView, profileId: tabManager.activeTab?.item.profileId)
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                    .padding()

                    if let activeTab = tabManager.activeTab {
                        if activeTab.webPage.url == nil || activeTab.webPage.url?.absoluteString == "about:blank" {
                            HomeScreenView(tabManager: tabManager, profileId: activeTab.item.profileId)
                        } else {
                            ZStack(alignment: .trailing) {
                                WebViewMacOS(
                                    webView: activeTab.webPage.webView,
                                    customCSS: CustomSiteManager.shared.getConfig(for: activeTab.webPage.url?.host ?? "").customCSS,
                                    customJS: CustomSiteManager.shared.getConfig(for: activeTab.webPage.url?.host ?? "").customJS
                                )
                                .onAppear {
                                    activeTab.webPage.onURLChange = { url, title in
                                        tabManager.recordVisit(url: url, title: title, profileId: activeTab.item.profileId)
                                    }
                                }

                                if isShowingCustomSiteEditor, let host = activeTab.webPage.url?.host {
                                    CustomSiteEditorMacOSWrapper(host: host)
                                        .transition(.move(edge: .trailing))
                                }
                            }
                        }
                    } else {
                        HomeScreenView(tabManager: tabManager, profileId: profiles.first?.id ?? UUID())
                    }
                }

                if isShowingAISidebar {
                    Divider()
                    AIPanelView(
                        streamingManager: streamingManager,
                        conversationManager: conversationManager,
                        modelManager: modelManager,
                        aiService: aiService,
                        activeTab: tabManager.activeTab
                    )
                    .frame(width: 300)
                    .transition(.move(edge: .trailing))
                }
            }
        }
        .onAppear {
            if tabManager.tabs.isEmpty {
                let profileId = profiles.first?.id ?? UUID()
                tabManager.createTab(url: nil, profileId: profileId)
            }
            if let first = profiles.first {
                uiConfig = ThemeManager.shared.getConfiguration(for: first.id)
            }
            registerCommands()
        }
        .onChange(of: tabManager.activeTab?.webPage.url) { _, newValue in
            if let url = newValue {
                urlText = url.absoluteString
            }
        }
        .accentColor(accentColor)
    }

    private func registerCommands() {
        CommandManager.shared.register(command: "new tab") {
            tabManager.createTab(url: nil, profileId: profiles.first?.id ?? UUID())
        }
        CommandManager.shared.register(command: "close tab") {
            if let id = tabManager.activeTabId {
                tabManager.closeTab(id: id)
            }
        }
        CommandManager.shared.register(command: "reopen tab") {
            tabManager.reopenLastClosedTab(profileId: profiles.first?.id ?? UUID())
        }
        CommandManager.shared.register(command: "open downloads") {
            // Logic to show downloads (could be a sheet or navigation)
        }
    }

    private var accentColor: Color {
        guard let config = uiConfig else { return .blue }
        switch config.accentColor {
        case "red": return .red
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        default: return .blue
        }
    }

struct CustomSiteEditorMacOSWrapper: View {
    @State private var viewModel = CustomSiteViewModel()
    let host: String

    var body: some View {
        CustomSiteEditorMacOS(viewModel: viewModel)
            .onAppear {
                viewModel.loadConfig(for: host)
            }
    }
}

    private func loadURL() {
        let result = CommandManager.shared.parse(urlText)

        switch result {
        case .url(let url):
            if let activeTab = tabManager.activeTab {
                activeTab.webPage.load(url: url)
            } else {
                tabManager.createTab(url: url, profileId: profiles.first?.id ?? UUID())
            }
        case .search(let query):
            let url = SearchProviderManager.shared.searchURL(for: query)
            if let activeTab = tabManager.activeTab {
                activeTab.webPage.load(url: url)
            } else {
                tabManager.createTab(url: url, profileId: profiles.first?.id ?? UUID())
            }
        case .askGPT(let query):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let url = URL(string: "https://chatgpt.com/?q=\(encodedQuery)")!
            tabManager.createTab(url: url, profileId: profiles.first?.id ?? UUID())
        case .browserCommand(let action):
            action()
            urlText = ""
        case .none:
            break
        }
    }
}
#endif
