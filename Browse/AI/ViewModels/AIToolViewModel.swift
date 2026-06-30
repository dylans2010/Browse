import Foundation

@Observable
final class AIToolViewModel {
    private let aiService = AIService.shared

    var result: String = ""
    var isProcessing: Bool = false
    var errorMessage: String?

    func summarize(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.summaryPrompt(content: content)) }
    }

    func translate(content: String, to language: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.translationPrompt(content: content, targetLanguage: language)) }
    }

    func explain(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.explanationPrompt(content: content)) }
    }

    func cleanForReader(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.readingModePrompt(content: content)) }
    }

    func factCheck(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.factCheckPrompt(content: content)) }
    }

    func generateCitations(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.citationPrompt(content: content)) }
    }

    func improveWriting(content: String, instructions: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.writingAssistantPrompt(content: content, instructions: instructions)) }
    }

    func generateEmail(context: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.emailGeneratorPrompt(context: context)) }
    }

    func summarizeMeeting(transcript: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.meetingSummaryPrompt(transcript: transcript)) }
    }

    func extractRecipe(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.recipeExtractionPrompt(content: content)) }
    }

    func compareProducts(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.shoppingComparisonPrompt(productContent: content)) }
    }

    func planTravel(destination: String, duration: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.travelPlanningPrompt(destination: destination, duration: duration)) }
    }

    func helpAccessibility(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.accessibilityAssistantPrompt(content: content)) }
    }

    func simplifyPage(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.pageSimplifierPrompt(content: content)) }
    }

    func reviewCode(code: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.codeReviewPrompt(code: code)) }
    }

    func generateRegex(description: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.regexGeneratorPrompt(description: description)) }
    }

    func formatJSON(json: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.jsonFormatterPrompt(json: json)) }
    }

    func generateQuiz(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.quizGeneratorPrompt(content: content)) }
    }

    func generateFlashcards(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.flashcardGeneratorPrompt(content: content)) }
    }

    func generateTimeline(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.timelineGeneratorPrompt(content: content)) }
    }

    func generateGlossary(content: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.glossaryGeneratorPrompt(content: content)) }
    }

    func suggestTabGroups(titles: [String]) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.tabGroupingPrompt(tabTitles: titles)) }
    }

    func recommendWorkspaces(history: [String]) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.workspaceRecommendationPrompt(history: history)) }
    }

    func searchHistory(query: String, history: [String]) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.historySearchPrompt(query: query, history: history)) }
    }

    func organizeBookmarks(bookmarks: [String]) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.bookmarkOrganizationPrompt(bookmarks: bookmarks)) }
    }

    func improveDownload(filename: String) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.downloadCategorizationPrompt(filename: filename)) }
    }

    func explainScreenshot() async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.screenshotExplanationPrompt()) }
    }

    func findCommand(query: String, commands: [String]) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.commandPaletteAssistantPrompt(query: query, availableCommands: commands)) }
    }

    func summarizeSession(tabs: [String]) async {
        await executeAI { try await aiService.complete(prompt: PromptLibrary.sessionSummaryPrompt(tabs: tabs)) }
    }

    private func executeAI(_ operation: @escaping () async throws -> String) async {
        isProcessing = true
        errorMessage = nil
        defer { isProcessing = false }
        do {
            result = try await operation()
        } catch {
            errorMessage = error.localizedDescription
            LoggingService.shared.error("AI operation failed", error: error)
        }
    }
}
