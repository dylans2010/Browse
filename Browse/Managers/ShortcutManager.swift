import Foundation
import Observation

struct KeyboardShortcut: Identifiable, Codable {
    let id: UUID
    var action: String
    var key: String
    var modifiers: [String]
}

@Observable
final class ShortcutManager {
    static let shared = ShortcutManager()

    var shortcuts: [KeyboardShortcut] = [
        KeyboardShortcut(id: UUID(), action: "New Tab", key: "T", modifiers: ["Command"]),
        KeyboardShortcut(id: UUID(), action: "Close Tab", key: "W", modifiers: ["Command"]),
        KeyboardShortcut(id: UUID(), action: "Reload", key: "R", modifiers: ["Command"])
    ]
}
