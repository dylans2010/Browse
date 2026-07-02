import Foundation
import Observation
import SwiftData
import WebKit

@Observable
final class TabManager {
    struct TabWrapper: Identifiable {
        let id: UUID
        let item: Tab
        let webPage: WebPageManager
    }

    var tabs: [TabWrapper] = []
    var activeTabId: UUID?
    var pinnedTabIds: Set<UUID> = []
    var recentlyClosedTabs: [Tab] = []
    private let context = PersistenceProvider.shared.mainContext

    var activeTab: TabWrapper? {
        tabs.first { $0.id == activeTabId }
    }

    @MainActor
    func createTab(url: URL? = nil, profileId: UUID) {
        let item = Tab(url: url, profileId: profileId)
        context.insert(item)
        try? context.save()

        // WKWebView identity contract: retrieved once from the pool, keyed by Tab.id
        let config = WKWebViewConfiguration()
        let pool = WKProcessPool()
        config.processPool = pool

        let webView = WebViewPool.shared.webView(for: item.id, configuration: config)

        let webPage = WebPageManager(tabID: item.id, webView: webView, tabManager: self)
        if let url = url {
            webPage.load(url: url)
        } else {
            webPage.load(url: URL(string: "about:blank")!)
        }
        let tab = TabWrapper(id: item.id, item: item, webPage: webPage)
        tabs.append(tab)
        activeTabId = tab.id
    }

    @MainActor
    func closeTab(id: UUID) {
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            let tab = tabs[index]
            recentlyClosedTabs.append(tab.item)
            context.delete(tab.item)
            try? context.save()
            tabs.remove(at: index)
            pinnedTabIds.remove(id)

            // Clean up web view pool
            WebViewPool.shared.removeWebView(for: id)
        }

        if activeTabId == id {
            activeTabId = tabs.last?.id
        }
    }

    @MainActor
    func closeAllTabs() {
        for tab in tabs {
            recentlyClosedTabs.append(tab.item)
            context.delete(tab.item)
            WebViewPool.shared.removeWebView(for: tab.id)
        }
        try? context.save()
        tabs.removeAll()
        pinnedTabIds.removeAll()
        activeTabId = nil
    }

    func pinTab(id: UUID) {
        pinnedTabIds.insert(id)
    }

    func unpinTab(id: UUID) {
        pinnedTabIds.remove(id)
    }

    @MainActor
    func reopenLastClosedTab(profileId: UUID) {
        guard let last = recentlyClosedTabs.popLast() else { return }
        createTab(url: last.url, profileId: profileId)
    }

    func selectTab(id: UUID) {
        activeTabId = id
        if let tab = activeTab {
            tab.item.lastActive = Date()
            try? context.save()
        }
    }

    func recordVisit(url: URL, title: String, profileId: UUID) {
        let fetchDescriptor = FetchDescriptor<HistoryItem>(
            predicate: #Predicate { $0.url == url && $0.profileId == profileId }
        )

        if let existing = try? context.fetch(fetchDescriptor).first {
            existing.visitCount += 1
            existing.timestamp = Date()
            existing.title = title
        } else {
            let newItem = HistoryItem(url: url, title: title, profileId: profileId)
            context.insert(newItem)
        }
        try? context.save()
    }

    // In-place mutation methods
    @MainActor
    func updateTitle(for tabID: UUID, title: String) {
        guard let tab = tabs.first(where: { $0.id == tabID }) else { return }
        tab.item.title = title
    }

    @MainActor
    func updateFavicon(for tabID: UUID, data: Data) {
        guard let tab = tabs.first(where: { $0.id == tabID }) else { return }
        tab.item.faviconData = data
    }

    @MainActor
    func updateLoadingState(for tabID: UUID, isLoading: Bool, progress: Double) {
        guard let tab = tabs.first(where: { $0.id == tabID }) else { return }
        tab.item.isLoading = isLoading
        tab.item.loadingProgress = progress
    }

    @MainActor
    func updateAudioState(for tabID: UUID, isPlaying: Bool) {
        guard let tab = tabs.first(where: { $0.id == tabID }) else { return }
        tab.item.isPlayingAudio = isPlaying
    }
}

extension TabManager {
    func moveTab(from source: Int, to destination: Int) {
        tabs.insert(tabs.remove(at: source), at: destination)
    }
}
