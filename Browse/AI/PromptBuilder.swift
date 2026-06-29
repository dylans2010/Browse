import Foundation

/// Builds prompts from templates for various AI features.
struct PromptBuilder {
    enum Template {
        case summarize(content: String)
        case explain(content: String)
        case translate(content: String, targetLanguage: String)
        case rewrite(content: String, tone: String)

        var prompt: String {
            switch self {
            case .summarize(let content):
                return "Please provide a concise summary of the following webpage content:\n\n\(content)"
            case .explain(let content):
                return "Explain the key concepts of the following content in an easy-to-understand way:\n\n\(content)"
            case .translate(let content, let lang):
                return "Translate the following text to \(lang):\n\n\(content)"
            case .rewrite(let content, let tone):
                return "Rewrite the following text in a \(tone) tone:\n\n\(content)"
            }
        }
    }

    static func build(_ template: Template) -> String {
        return template.prompt
    }
}
