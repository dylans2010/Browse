import Foundation

extension PromptLibrary {
    static func downloadCategorizationPrompt(filename: String) -> String {
        return "Suggest a category and a better, more descriptive filename for a file originally named '\(filename)':"
    }

    static func screenshotExplanationPrompt() -> String {
        return "Describe what is happening in this screenshot and explain any text or elements visible."
    }
}
