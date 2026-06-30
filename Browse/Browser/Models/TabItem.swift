import Foundation
import SwiftData

@Model
final class TabItem {
    var id: UUID
    var url: URL?
    var title: String
    var profileId: UUID
    var workspaceId: UUID? // Added for workspace support
    var lastActive: Date
    var groupId: UUID?
    var parentTabId: UUID?
    var isPinned: Bool

    init(url: URL? = nil, title: String = "New Tab", profileId: UUID, workspaceId: UUID? = nil, groupId: UUID? = nil, isPinned: Bool = false) {
        self.id = UUID()
        self.url = url
        self.title = title
        self.profileId = profileId
        self.workspaceId = workspaceId
        self.lastActive = Date()
        self.groupId = groupId
        self.isPinned = isPinned
    }
}
