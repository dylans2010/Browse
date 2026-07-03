import Foundation
import Observation

@Observable
final class CommandManager {
    static let shared = CommandManager()

    enum CommandResult {
        case url(URL)
        case search(String)
        case askGPT(String)
        case browserCommand(() -> Void)
        case none
    }

    func parse(_ input: String) -> CommandResult {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .none }

        let lowercase = trimmed.lowercased()

        // 1. Check for browser commands
        if let action = matchCommand(lowercase) {
            return .browserCommand(action)
        }

        // 2. Check for URL (Priority over Ask GPT to avoid breaking URLs with ?)
        if trimmed.contains("://") || (trimmed.contains(".") && !trimmed.contains(" ")) {
            let urlString = trimmed.contains("://") ? trimmed : "https://\(trimmed)"
            if let url = URL(string: urlString) {
                return .url(url)
            }
        }

        // 3. Check for Ask GPT (More specific prefixes or terminal ?)
        if lowercase.hasPrefix("ask ") || lowercase.hasPrefix("gpt ") || lowercase.hasSuffix("?") {
            let query = lowercase.hasPrefix("ask ") ? String(trimmed.dropFirst(4)) : (lowercase.hasPrefix("gpt ") ? String(trimmed.dropFirst(4)) : trimmed)
            return .askGPT(query)
        }

        // 4. Default to Search
        return .search(trimmed)
    }

    private var commands: [String: () -> Void] = [:]

    init() {
        registerDefaultCommands()
    }

    func register(command: String, action: @escaping () -> Void) {
        commands[command.lowercased()] = action
    }

    func matchCommand(_ input: String) -> (() -> Void)? {
        return commands[input.lowercased()]
    }

    var allCommands: [String] {
        return Array(commands.keys)
    }

    private func registerDefaultCommands() {
        // Default commands will be wired up by the views/managers that can handle them
    }
}
