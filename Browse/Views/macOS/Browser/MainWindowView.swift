import SwiftUI
import SwiftData

struct MainWindowView: View {
    @State private var tabManager = TabManager()
    @State private var streamingManager = StreamingManager()
    @State private var conversationManager = ConversationManager()
    @State private var modelManager = ModelManager()
    private let aiService = AIService.shared
    @State private var urlText: String = ""
    @State private var isShowingAISidebar: Bool = false
    @State private var isReaderModeActive: Bool = false
    @Query private var profiles: [Profile]

    var body: some View {
        NavigationSplitView {
            SidebarViewMacOS(tabManager: tabManager)
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
                        WebViewMacOS(webView: activeTab.webPage.webView)
                            .onAppear {
                                activeTab.webPage.onURLChange = { url, title in
                                    tabManager.recordVisit(url: url, title: title, profileId: activeTab.item.profileId)
                                }
                            }
                    } else {
                        ContentUnavailableView("No Open Tabs", systemImage: "plus.circle", description: Text("Click + to start browsing"))
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
                tabManager.createTab(url: URL(string: "https://www.apple.com"), profileId: profileId)
            }
        }
        .onChange(of: tabManager.activeTab?.webPage.url) { _, newValue in
            if let url = newValue {
                urlText = url.absoluteString
            }
        }
    }

    private func loadURL() {
        guard let activeTab = tabManager.activeTab else { return }
        var targetURL: URL?

        if urlText.contains("://") {
            targetURL = URL(string: urlText)
        } else if urlText.contains(".") {
            targetURL = URL(string: "https://\(urlText)")
        } else {
            targetURL = SearchProviderManager.shared.searchURL(for: urlText)
        }

        if let url = targetURL {
            activeTab.webPage.load(url: url)
        }
    }
}
