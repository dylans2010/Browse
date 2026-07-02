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
    @State private var isShowingToolsMenu = false

    var body: some View {
        NavigationSplitView {
            SidebarViewMacOS(tabManager: tabManager)
        } detail: {
            VStack(spacing: 0) {
                // Toolbar
                HStack(spacing: 12) {
                    Button(action: { tabManager.activeTab?.webPage.goBack() }) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!(tabManager.activeTab?.webPage.canGoBack ?? false))
                    .buttonStyle(.plain)

                    Button(action: { tabManager.activeTab?.webPage.goForward() }) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!(tabManager.activeTab?.webPage.canGoForward ?? false))
                    .buttonStyle(.plain)

                    AddressBarViewMacOS(
                        text: $urlText,
                        isLoading: tabManager.activeTab?.webPage.isLoading ?? false,
                        progress: tabManager.activeTab?.webPage.estimatedProgress ?? 0,
                        isReaderAvailable: tabManager.activeTab?.webPage.isReaderAvailable ?? false,
                        isReaderModeActive: $isReaderModeActive,
                        onCommit: { loadURL() },
                        onReload: { tabManager.activeTab?.webPage.reload() }
                    )
                    .frame(maxWidth: 600)

                    Button(action: { isShowingToolsMenu.toggle() }) {
                        Image(systemName: "ellipsis.circle")
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $isShowingToolsMenu) {
                        ToolsMenuMacOS(activeTab: tabManager.activeTab)
                    }

                    Button(action: { isShowingAISidebar.toggle() }) {
                        Image(systemName: "sparkles")
                            .foregroundColor(isShowingAISidebar ? .accentColor : .primary)
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.bar)

                Divider()

                if !(uiConfig?.useVerticalTabs ?? true) {
                    TabBarMacOS(tabManager: tabManager)
                    Divider()
                }

                // Content
                HStack(spacing: 0) {
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

                                if isShowingCustomSiteEditor, let host = activeTab.webPage.url?.host {
                                    CustomSiteEditorMacOSWrapper(host: host)
                                        .transition(.move(edge: .trailing))
                                }
                            }
                        }
                    } else {
                        HomeScreenView(tabManager: tabManager, profileId: profiles.first?.id ?? UUID())
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
                .animation(.default, value: isShowingAISidebar)
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
        }
        .onChange(of: tabManager.activeTab?.webPage.url) { _, newValue in
            if let url = newValue {
                urlText = url.absoluteString
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
            if let url = SearchProviderManager.shared.searchURL(for: query) {
                if let activeTab = tabManager.activeTab {
                    activeTab.webPage.load(url: url)
                } else {
                    tabManager.createTab(url: url, profileId: profiles.first?.id ?? UUID())
                }
            }
        default: break
        }
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
#endif
