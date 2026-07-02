import Foundation
import Observation
import SwiftData

@Observable
final class TabManager {
    struct Tab: Identifiable {
        let id: UUID
        let item: TabItem
        let webPage: WebPageManager
    }

    var tabs: [Tab] = []
    var activeTabId: UUID?
    var pinnedTabIds: Set<UUID> = []
    var recentlyClosedTabs: [TabItem] = []
    private let context = PersistenceProvider.shared.mainContext

    var activeTab: Tab? {
        tabs.first { $0.id == activeTabId }
    }

    func createTab(url: URL? = nil, profileId: UUID) {
        let item = TabItem(url: url, profileId: profileId)
        context.insert(item)
        try? context.save()

        let webPage = WebPageManager()
        if let url = url {
            webPage.load(url: url)
        } else {
            // New tab with no URL defaults to home
            webPage.load(url: URL(string: "about:blank")!)
        }
        let tab = Tab(id: item.id, item: item, webPage: webPage)
        tabs.append(tab)
        activeTabId = tab.id
    }

    func closeTab(id: UUID) {
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            let tab = tabs[index]
            recentlyClosedTabs.append(tab.item)
            context.delete(tab.item)
            try? context.save()
            tabs.remove(at: index)
            pinnedTabIds.remove(id)
        }

        if activeTabId == id {
            activeTabId = tabs.last?.id
        }
    }

    func closeAllTabs() {
        for tab in tabs {
            recentlyClosedTabs.append(tab.item)
            context.delete(tab.item)
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
}
