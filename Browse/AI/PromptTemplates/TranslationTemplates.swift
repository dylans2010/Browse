import Foundation

extension PromptLibrary {
    static func translationPrompt(content: String, targetLanguage: String) -> String {
        return "Translate the following content to \(targetLanguage):\n\n\(content)"
    }
}
