import Foundation

extension PromptLibrary {
    static func meetingSummaryPrompt(transcript: String) -> String {
        return "Summarize this meeting transcript, highlighting key decisions, action items, and participants:\n\n\(transcript)"
    }

    static func recipeExtractionPrompt(content: String) -> String {
        return "Extract the recipe from this page content, including ingredients, instructions, and serving size, formatted clearly:\n\n\(content)"
    }
}
