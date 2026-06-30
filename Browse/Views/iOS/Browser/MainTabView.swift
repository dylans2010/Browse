import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var tabManager = TabManager()
    @State private var isShowingTabSwitcher = false
    @State private var isShowingMenu = false
    @State private var urlText: String = ""
    @State private var isReaderModeActive: Bool = false
    @Query private var profiles: [Profile]

    var body: some View {
        VStack(spacing: 0) {
            // Address bar — previously missing entirely on iOS.
            AddressBarView(
                text: $urlText,
                isLoading: tabManager.activeTab?.webPage.isLoading ?? false,
                progress: tabManager.activeTab?.webPage.estimatedProgress ?? 0,
                isReaderAvailable: tabManager.activeTab?.webPage.isReaderAvailable ?? false,
                isReaderModeActive: $isReaderModeActive,
                onCommit: { loadURL() },
                onReload: { tabManager.activeTab?.webPage.reload() }
            )
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)

            if let activeTab = tabManager.activeTab {
                WebView(webView: activeTab.webPage.webView)
                    .onAppear {
                        activeTab.webPage.onURLChange = { url, title in
                            urlText = url.absoluteString
                            tabManager.recordVisit(url: url, title: title, profileId: activeTab.item.profileId)
                        }
                    }
                    .overlay(alignment: .top) {
                        if activeTab.webPage.isLoading {
                            ProgressView(value: activeTab.webPage.estimatedProgress)
                                .progressViewStyle(.linear)
                                .frame(height: 2)
                        }
                    }
            } else {
                ContentUnavailableView("No Open Tabs", systemImage: "plus.circle")
            }

            // Bottom navigation bar
            HStack {
                Button(action: { tabManager.activeTab?.webPage.goBack() }) {
                    Image(systemName: "chevron.left")
                }
                .disabled(!(tabManager.activeTab?.webPage.canGoBack ?? false))

                Spacer()

                Button(action: { tabManager.activeTab?.webPage.goForward() }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(!(tabManager.activeTab?.webPage.canGoForward ?? false))

                Spacer()

                Button(action: { shareCurrentTab() }) {
                    Image(systemName: "square.and.arrow.up")
                }

                Spacer()

                Button(action: { isShowingTabSwitcher = true }) {
                    ZStack {
                        Image(systemName: "square")
                        Text("\(tabManager.tabs.count)")
                            .font(.system(size: 10, weight: .bold))
                    }
                }

                Spacer()

                Button(action: { isShowingMenu = true }) {
                    Image(systemName: "ellipsis")
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .onAppear {
            if tabManager.tabs.isEmpty {
                // Fixed: use the stored default profile instead of a random UUID.
                let profileId = profiles.first?.id ?? UUID()
                tabManager.createTab(url: URL(string: "https://www.apple.com"), profileId: profileId)
            }
        }
        .onChange(of: tabManager.activeTab?.webPage.url) { _, newValue in
            if let url = newValue {
                urlText = url.absoluteString
            }
        }
        .fullScreenCover(isPresented: $isShowingTabSwitcher) {
            TabSwitcher(tabManager: tabManager)
        }
        .sheet(isPresented: $isShowingMenu) {
            NavigationStack {
                List {
                    Section {
                        Button("New Tab") {
                            // Fixed: use the stored default profile instead of a random UUID.
                            let profileId = profiles.first?.id ?? UUID()
                            tabManager.createTab(url: URL(string: "https://www.google.com"), profileId: profileId)
                            isShowingMenu = false
                        }
                        Button("Bookmarks") { /* Navigate */ }
                        Button("History") { /* Navigate */ }
                        Button("Downloads") { /* Navigate */ }
                    }
                    Section {
                        NavigationLink("Settings") {
                            SettingsView(aiSettings: AISettings())
                        }
                    }
                }
                .navigationTitle("Menu")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium])
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

    private func shareCurrentTab() {
        guard let url = tabManager.activeTab?.webPage.url else { return }
        #if os(iOS)
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
        #endif
    }
}
