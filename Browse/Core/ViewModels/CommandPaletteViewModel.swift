import Foundation
import Observation

@Observable
final class CommandPaletteViewModel {
    struct Command: Identifiable {
        let id = UUID()
        let name: String
        let action: () -> Void
    }

    var commands: [Command] = []
    var filteredCommands: [Command] = []

    func setupCommands(actions: [String: () -> Void]) {
        commands = actions.map { Command(name: $0.key, action: $0.value) }
        filteredCommands = commands
    }

    func filter(query: String) {
        if query.isEmpty {
            filteredCommands = commands
        } else {
            filteredCommands = commands.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }
}
