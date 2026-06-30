import Foundation

extension PromptLibrary {
    static func writingAssistantPrompt(content: String, instructions: String) -> String {
        return "Improve the following text based on these instructions: \(instructions)\n\nText:\n\(content)"
    }

    static func emailGeneratorPrompt(context: String) -> String {
        return "Draft a professional email based on the following context or webpage content:\n\n\(context)"
    }
}
