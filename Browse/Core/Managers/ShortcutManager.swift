import Foundation
import SwiftData
import Observation

@Observable
final class ShortcutManager {
    static let shared = ShortcutManager()
    private let context = PersistenceProvider.shared.mainContext

    var shortcuts: [KeyboardShortcut] = []

    func fetchShortcuts() {
        let descriptor = FetchDescriptor<KeyboardShortcut>()
        shortcuts = (try? context.fetch(descriptor)) ?? []
    }

    func updateShortcut(action: String, key: String) {
        if let existing = shortcuts.first(where: { $0.action == action }) {
            existing.keyCombination = key
        } else {
            let newShortcut = KeyboardShortcut(action: action, keyCombination: key)
            context.insert(newShortcut)
        }
        try? context.save()
        fetchShortcuts()
    }
}
