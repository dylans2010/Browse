import Foundation
import Observation

/// Higher-level service for AI features. AIService is the sole entry point for AI.
@MainActor
@Observable
final class AIService {
    static let shared = AIService()

    private let client = OpenRouterClient()
    private let rateLimiter = AIRateLimiter()
    private let tokenEstimator = AITokenEstimator()

    var isProcessing: Bool = false
    var lastError: String?

    private init() {}

    /// Summarizes the provided text with retry support and exponential backoff.
    func summarize(text: String, model: String = "openai/gpt-3.5-turbo", retries: Int = 3) async throws -> String {
        var attempts = 0
        while attempts < retries {
            do {
                return try await performSummarize(text: text, model: model)
            } catch {
                attempts += 1
                if attempts >= retries { throw error }
                let backoff = UInt64(pow(2.0, Double(attempts)) * 1_000_000_000)
                try? await Task.sleep(nanoseconds: backoff)
            }
        }
        throw AIError.requestFailed
    }

    private func performSummarize(text: String, model: String) async throws -> String {
        guard rateLimiter.canMakeRequest() else {
            throw AIError.rateLimitExceeded
        }

        isProcessing = true
        defer { isProcessing = false }

        rateLimiter.recordRequest()

        let prompt = PromptBuilder.build(.summarize(content: text))
        let messages = [OpenRouterModels.Message(role: "user", content: prompt)]

        do {
            let response = try await client.complete(model: model, messages: messages)
            return ResponseParser.parse(response)
        } catch {
            lastError = AIErrorHandler.handle(error)
            throw error
        }
    }

    /// Explains the provided text.
    func explain(text: String, model: String = "openai/gpt-3.5-turbo") async throws -> String {
        guard rateLimiter.canMakeRequest() else {
            throw AIError.rateLimitExceeded
        }

        isProcessing = true
        defer { isProcessing = false }

        rateLimiter.recordRequest()

        let prompt = PromptBuilder.build(.explain(content: text))
        let messages = [OpenRouterModels.Message(role: "user", content: prompt)]

        do {
            let response = try await client.complete(model: model, messages: messages)
            return ResponseParser.parse(response)
        } catch {
            lastError = AIErrorHandler.handle(error)
            throw error
        }
    }

    /// Provides a streaming interface for AI requests.
    func stream(model: String, messages: [OpenRouterModels.Message]) -> AsyncThrowingStream<String, Error> {
        return client.stream(model: model, messages: messages)
    }
}
