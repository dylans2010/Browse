import Foundation
import SwiftData

@Model
final class SessionSnapshot {
    var id: UUID
    var name: String
    var profileId: UUID
    var workspaceId: UUID?
    var createdAt: Date
    var tabItems: [TabSnapshot]

    init(name: String, profileId: UUID, workspaceId: UUID? = nil, tabItems: [TabSnapshot]) {
        self.id = UUID()
        self.name = name
        self.profileId = profileId
        self.workspaceId = workspaceId
        self.createdAt = Date()
        self.tabItems = tabItems
    }
}

@Model
final class TabSnapshot {
    var url: URL?
    var title: String

    init(url: URL?, title: String) {
        self.url = url
        self.title = title
    }
}
