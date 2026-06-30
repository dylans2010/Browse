import Foundation

extension PromptLibrary {
    static func historySearchPrompt(query: String, history: [String]) -> String {
        let list = history.joined(separator: "\n")
        return "Find the most relevant items in this browsing history for the query '\(query)':\n\n\(list)"
    }

    static func bookmarkOrganizationPrompt(bookmarks: [String]) -> String {
        let list = bookmarks.joined(separator: ", ")
        return "Organize the following bookmarks into logical folders and suggest appropriate titles and icons:\n\n\(list)"
    }
}
