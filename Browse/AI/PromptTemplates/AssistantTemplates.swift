import Foundation

extension PromptLibrary {
    static func commandPaletteAssistantPrompt(query: String, availableCommands: [String]) -> String {
        let list = availableCommands.joined(separator: ", ")
        return "Find the most appropriate command for the query '\(query)' from this list: \(list)"
    }

    static func sessionSummaryPrompt(tabs: [String]) -> String {
        let list = tabs.joined(separator: ", ")
        return "Summarize the following browsing session based on these open tab titles:\n\n\(list)"
    }
}
