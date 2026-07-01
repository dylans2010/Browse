import Foundation
import Observation

@Observable
final class SessionViewModel {
    private let manager = SessionSnapshotManager.shared

    var snapshots: [SessionSnapshot] { manager.snapshots }

    func takeSnapshot(name: String, profileId: UUID, tabs: [TabItem]) {
        manager.createSnapshot(name: name, profileId: profileId, tabs: tabs)
    }
}
