import Foundation
import SwiftData
import Observation

@Observable
final class WorkspaceManager {
    static let shared = WorkspaceManager()
    private let context = PersistenceProvider.shared.mainContext

    var workspaces: [Workspace] = []
    var activeWorkspaceId: UUID?

    func fetchWorkspaces(for profileId: UUID) {
        let descriptor = FetchDescriptor<Workspace>(
            predicate: #Predicate { $0.profileId == profileId },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        workspaces = (try? context.fetch(descriptor)) ?? []
        if activeWorkspaceId == nil {
            activeWorkspaceId = workspaces.first?.id
        }
    }

    func createWorkspace(name: String, icon: String, color: String, profileId: UUID) {
        let workspace = Workspace(name: name, icon: icon, color: color, profileId: profileId)
        context.insert(workspace)
        try? context.save()
        fetchWorkspaces(for: profileId)
    }
}
