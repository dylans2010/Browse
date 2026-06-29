import SwiftUI

struct MainTabView: View {
    @State private var tabManager = TabManager()
    @State private var isShowingTabSwitcher = false
    @State private var isShowingMenu = false

    var body: some View {
        VStack(spacing: 0) {
            if let activeTab = tabManager.activeTab {
                WebView(webView: activeTab.webPage.webView)
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

            // Bottom Bar
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
                tabManager.createTab(url: URL(string: "https://www.apple.com"), profileId: UUID())
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
                            tabManager.createTab(url: URL(string: "https://www.google.com"), profileId: UUID())
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
