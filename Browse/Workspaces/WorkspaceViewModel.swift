import Foundation
import Observation

@Observable
final class WorkspaceViewModel {
    private let manager = WorkspaceManager.shared

    var workspaces: [Workspace] { manager.workspaces }
    var activeWorkspaceId: UUID? {
        get { manager.activeWorkspaceId }
        set { manager.activeWorkspaceId = newValue }
    }

    func addWorkspace(name: String, icon: String, color: String, profileId: UUID) {
        manager.createWorkspace(name: name, icon: icon, color: color, profileId: profileId)
    }
}
