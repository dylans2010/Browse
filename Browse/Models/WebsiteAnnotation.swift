import Foundation
import SwiftData

@Model
final class WebsiteNote {
    var id: UUID
    var url: URL
    var content: String
    var createdAt: Date
    var profileId: UUID

    init(url: URL, content: String, profileId: UUID) {
        self.id = UUID()
        self.url = url
        self.content = content
        self.createdAt = Date()
        self.profileId = profileId
    }
}

@Model
final class WebsiteLabel {
    var id: UUID
    var url: URL
    var name: String
    var color: String
    var profileId: UUID

    init(url: URL, name: String, color: String = "blue", profileId: UUID) {
        self.id = UUID()
        self.url = url
        self.name = name
        self.color = color
        self.profileId = profileId
    }
}
