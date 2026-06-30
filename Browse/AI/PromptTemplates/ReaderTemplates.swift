import Foundation

extension PromptLibrary {
    static func explanationPrompt(content: String) -> String {
        return "Explain the following content in simple terms:\n\n\(content)"
    }

    static func readingModePrompt(content: String) -> String {
        return "Clean up the following HTML content for reading mode, removing ads and sidebars, and return just the main text formatted in Markdown:\n\n\(content)"
    }
}
