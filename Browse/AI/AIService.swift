import Foundation
import Observation

/// Higher-level service for AI features.
@Observable
final class AIService {
    private let client = OpenRouterClient()
    var isProcessing: Bool = false

    /// Summarizes the provided text.
    func summarize(text: String, model: String = "openai/gpt-3.5-turbo") async throws -> String {
        let prompt = "Summarize the following text concisely:\n\n\(text)"
        let messages = [OpenRouterModels.Message(role: "user", content: prompt)]
        return try await client.complete(model: model, messages: messages)
    }

    /// Explains the provided text.
    func explain(text: String, model: String = "openai/gpt-3.5-turbo") async throws -> String {
        let prompt = "Explain the following text in simple terms:\n\n\(text)"
        let messages = [OpenRouterModels.Message(role: "user", content: prompt)]
        return try await client.complete(model: model, messages: messages)
    }
}
