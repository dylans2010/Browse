import Foundation
import SwiftData

@Model
final class Tab {
    @Attribute(.unique) var id: UUID
    var url: URL?
    var title: String
    var profileId: UUID
    var workspaceId: UUID?
    var lastActive: Date
    var groupId: UUID?
    var parentTabId: UUID?
    var isPinned: Bool

    // Metadata for the UI pipeline
    var faviconData: Data?
    var isLoading: Bool = false
    var loadingProgress: Double = 0.0
    var isPlayingAudio: Bool = false
    var isMuted: Bool = false

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
