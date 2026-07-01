import Foundation
import SwiftData

@Model
final class Theme {
    var id: UUID
    var name: String
    var accentColor: String
    var backgroundColor: String
    var isDark: Bool

    init(name: String, accentColor: String = "blue", backgroundColor: String = "systemBackground", isDark: Bool = false) {
        self.id = UUID()
        self.name = name
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.isDark = isDark
    }
}
