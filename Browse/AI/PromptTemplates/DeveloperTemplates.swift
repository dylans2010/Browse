import Foundation

extension PromptLibrary {
    static func codeReviewPrompt(code: String) -> String {
        return "Perform a detailed code review of the following snippet, identifying bugs, performance issues, and readability improvements:\n\n\(code)"
    }

    static func regexGeneratorPrompt(description: String) -> String {
        return "Generate a regular expression for the following description, including examples of matching and non-matching strings:\n\n\(description)"
    }

    static func jsonFormatterPrompt(json: String) -> String {
        return "Format and validate the following JSON string, returning a pretty-printed version:\n\n\(json)"
    }
}
