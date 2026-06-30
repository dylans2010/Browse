import Foundation

extension PromptLibrary {
    static func tabGroupingPrompt(tabTitles: [String]) -> String {
        let list = tabTitles.joined(separator: ", ")
        return "Categorize the following open tab titles into logical groups and suggest a name for each group:\n\n\(list)"
    }

    static func workspaceRecommendationPrompt(history: [String]) -> String {
        let list = history.joined(separator: ", ")
        return "Based on the following browsing history, recommend 3-5 workspaces (with names and icons) that would help organize these sites:\n\n\(list)"
    }
}
