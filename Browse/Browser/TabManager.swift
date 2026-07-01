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
        }
        let tab = Tab(id: item.id, item: item, webPage: webPage)
        tabs.append(tab)
        activeTabId = tab.id
    }

    func closeTab(id: UUID) {
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            let tab = tabs[index]
            context.delete(tab.item)
            try? context.save()
            tabs.remove(at: index)
        }

        if activeTabId == id {
            activeTabId = tabs.last?.id
        }
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
