import Foundation
import SwiftData

@Model
final class KeyboardShortcut {
    var id: UUID
    var action: String
    var keyCombination: String // e.g., "cmd+t"

    init(action: String, keyCombination: String) {
        self.id = UUID()
        self.action = action
        self.keyCombination = keyCombination
    }
}
