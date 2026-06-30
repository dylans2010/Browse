import Foundation
import SwiftData
import Observation

@Observable
final class TabLogicManager {
    static let shared = TabLogicManager()
    private let context = PersistenceProvider.shared.mainContext

    /// Detects duplicate tabs based on URL.
    func findDuplicates(in tabs: [TabItem]) -> [TabItem] {
        var seenURLs = Set<URL>()
        var duplicates: [TabItem] = []

        for tab in tabs {
            if let url = tab.url {
                if seenURLs.contains(url) {
                    duplicates.append(tab)
                } else {
                    seenURLs.insert(url)
                }
            }
        }
        return duplicates
    }

    /// Archives tabs that haven't been active for a certain period.
    func archiveInactiveTabs(in tabs: [TabItem], thresholdDays: Int = 7) {
        let now = Date()
        let threshold = TimeInterval(thresholdDays * 24 * 60 * 60)

        for tab in tabs {
            if now.timeIntervalSince(tab.lastActive) > threshold {
                // In a production app, we would move these to an 'ArchivedTab' model or flag
                tab.isPinned = false // Just an example of modification
            }
        }
        try? context.save()
    }
}
