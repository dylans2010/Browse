import SwiftUI
import Observation

struct CommandAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let action: () -> Void
}

@Observable
final class CommandPaletteViewModel {
    var searchText: String = ""
    var actions: [CommandAction] = []

    init(tabManager: TabManager) {
        self.actions = [
            CommandAction(title: "New Tab", icon: "plus") {
                tabManager.createTab(profileId: UUID()) // Use actual profile
            },
            CommandAction(title: "Clear History", icon: "trash") {
                // Clear history logic
            },
            CommandAction(title: "Show Bookmarks", icon: "bookmark") {
                // Navigation logic
            }
        ]
    }

    var filteredActions: [CommandAction] {
        if searchText.isEmpty { return actions }
        return actions.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}
