import Foundation
import SwiftData

@Model
final class GestureCommand {
    var id: UUID
    var gestureType: String // "mouse" or "trackpad"
    var pattern: String // e.g., "L-R" for mouse, "3-finger-swipe" for trackpad
    var action: String

    init(gestureType: String, pattern: String, action: String) {
        self.id = UUID()
        self.gestureType = gestureType
        self.pattern = pattern
        self.action = action
    }
}
