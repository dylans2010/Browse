import Foundation
import SwiftData

@Model
final class Profile {
    var id: UUID
    var name: String
    var icon: String
    var isPrivate: Bool
    var createdAt: Date

    init(name: String, icon: String = "person", isPrivate: Bool = false) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.isPrivate = isPrivate
        self.createdAt = Date()
    }
}
