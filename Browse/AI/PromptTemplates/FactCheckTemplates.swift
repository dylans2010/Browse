import Foundation

extension PromptLibrary {
    static func factCheckPrompt(content: String) -> String {
        return "Verify the facts in the following content and list any potential inaccuracies or points that need verification:\n\n\(content)"
    }

    static func citationPrompt(content: String) -> String {
        return "Generate APA-style citations for the main sources or claims in the following content:\n\n\(content)"
    }
}
