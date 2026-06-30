import Foundation

extension PromptLibrary {
    static func quizGeneratorPrompt(content: String) -> String {
        return "Generate a multiple-choice quiz based on the following content, including an answer key:\n\n\(content)"
    }

    static func flashcardGeneratorPrompt(content: String) -> String {
        return "Create a set of flashcards (front and back) for the key terms and concepts in the following content:\n\n\(content)"
    }

    static func timelineGeneratorPrompt(content: String) -> String {
        return "Generate a chronological timeline of events based on the following content:\n\n\(content)"
    }

    static func glossaryGeneratorPrompt(content: String) -> String {
        return "Extract and define key terms from the following content to create a glossary:\n\n\(content)"
    }
}
