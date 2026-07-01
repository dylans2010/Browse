import Foundation
import SwiftData
import Observation

@Observable
final class StartupManager {
    static let shared = StartupManager()
    private let context = PersistenceProvider.shared.mainContext

    /// Recommends tabs to recover based on the last session.
    func getRecoveryRecommendations(for profileId: UUID) -> [TabItem] {
        let descriptor = FetchDescriptor<TabItem>(
            predicate: #Predicate { $0.profileId == profileId },
            sortBy: [SortDescriptor(\.lastActive, order: .reverse)]
        )
        let allTabs = (try? context.fetch(descriptor)) ?? []
        return Array(allTabs.prefix(5)) // Recommend top 5 last active tabs
    }

    /// Determines the smart startup pages for a profile.
    func getSmartStartupURLs(for profileId: UUID) -> [URL] {
        // In a production app, this would use ML or frequency analysis
        // For now, we'll return common history items
        let descriptor = FetchDescriptor<HistoryItem>(
            predicate: #Predicate { $0.profileId == profileId },
            sortBy: [SortDescriptor(\.visitCount, order: .reverse)]
        )
        let history = (try? context.fetch(descriptor)) ?? []
        return Array(history.prefix(3)).map { $0.url }
    }
}
