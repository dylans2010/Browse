import Foundation
import SwiftData

@Model
final class Workspace {
    var id: UUID
    var name: String
    var icon: String
    var color: String
    var profileId: UUID
    var createdAt: Date

    init(name: String, icon: String = "briefcase", color: String = "blue", profileId: UUID) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.color = color
        self.profileId = profileId
        self.createdAt = Date()
    }
}
