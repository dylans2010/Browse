import Foundation
import SwiftData
import Observation

@Observable
final class SessionSnapshotManager {
    static let shared = SessionSnapshotManager()
    private let context = PersistenceProvider.shared.mainContext

    var snapshots: [SessionSnapshot] = []

    func fetchSnapshots(for profileId: UUID) {
        let descriptor = FetchDescriptor<SessionSnapshot>(
            predicate: #Predicate { $0.profileId == profileId },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        snapshots = (try? context.fetch(descriptor)) ?? []
    }

    func createSnapshot(name: String, profileId: UUID, tabs: [TabItem]) {
        let tabSnapshots = tabs.map { TabItemSnapshot(url: $0.url, title: $0.title) }
        let snapshot = SessionSnapshot(name: name, profileId: profileId, tabItems: tabSnapshots)
        context.insert(snapshot)
        try? context.save()
        fetchSnapshots(for: profileId)
    }
}
