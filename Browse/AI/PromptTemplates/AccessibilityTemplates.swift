import Foundation

extension PromptLibrary {
    static func accessibilityAssistantPrompt(content: String) -> String {
        return "Analyze this page content and provide an audio-friendly summary and navigate-able structure for users with visual impairments:\n\n\(content)"
    }

    static func pageSimplifierPrompt(content: String) -> String {
        return "Rewrite the following content to be as simple as possible, suitable for a 5th-grade reading level, while maintaining all key information:\n\n\(content)"
    }
}
