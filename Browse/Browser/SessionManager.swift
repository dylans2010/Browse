import Foundation
import SwiftData

final class SessionManager {
    static let shared = SessionManager()
    private let context = PersistenceProvider.shared.mainContext

    func saveSession(tabs: [TabManager.Tab]) {
        // Use a more refined approach: update existing items or delete only session-related ones
        let profileId = tabs.first?.item.profileId ?? UUID()

        let fetchDescriptor = FetchDescriptor<Tab>(
            predicate: #Predicate { $0.profileId == profileId }
        )

        if let existingItems = try? context.fetch(fetchDescriptor) {
            for item in existingItems {
                context.delete(item)
            }
        }

        for tab in tabs {
            let item = Tab(
                url: tab.webPage.url,
                title: tab.webPage.title,
                profileId: tab.item.profileId,
                groupId: tab.item.groupId,
                isPinned: tab.item.isPinned
            )
            context.insert(item)
        }

        try? context.save()
    }

    func restoreSession(profileId: UUID) -> [Tab] {
        let fetchDescriptor = FetchDescriptor<Tab>(
            predicate: #Predicate { $0.profileId == profileId },
            sortBy: [SortDescriptor(\.lastActive)]
        )

        return (try? context.fetch(fetchDescriptor)) ?? []
    }
}
