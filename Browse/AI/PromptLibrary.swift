import Foundation

struct PromptLibrary {
    static let systemPrompt = "You are a helpful browser assistant."

    static func summaryPrompt(content: String) -> String {
        return "Summarize the following content concisely:\n\n\(content)"
    }
}
