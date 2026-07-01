import Foundation

/// Core AI Service - The sole public entry point for all AI features.
@Observable
final class AIService {
    static let shared = AIService()

    let client: OpenRouterClient
    let contextManager: AIContextManager
    let modelManager: ModelManager
    let rateLimiter: AIRateLimiter
    let tokenEstimator: AITokenEstimator
    let errorHandler: AIErrorHandler
    let responseParser: AIResponseParser

    private init() {
        self.client = OpenRouterClient()
        self.contextManager = AIContextManager()
        self.modelManager = ModelManager()
        self.rateLimiter = AIRateLimiter()
        self.tokenEstimator = AITokenEstimator()
        self.errorHandler = AIErrorHandler()
        self.responseParser = AIResponseParser()
    }

    /// Main completion method.
    func complete(prompt: String, context: String? = nil, model: String? = nil) async throws -> String {
        let selectedModel = model ?? modelManager.selectedModel

        try await rateLimiter.waitForAvailability()

        var messages = contextManager.getMessages()
        if let context = context {
            messages.append(OpenRouterModels.Message(role: "system", content: context))
        }
        messages.append(OpenRouterModels.Message(role: "user", content: prompt))

        do {
            let response = try await client.complete(model: selectedModel, messages: messages)
            contextManager.addMessage(OpenRouterModels.Message(role: "user", content: prompt))
            contextManager.addMessage(OpenRouterModels.Message(role: "assistant", content: response))
            return responseParser.parse(response)
        } catch {
            throw errorHandler.handle(error)
        }
    }

    /// Streaming completion method.
    func stream(prompt: String, context: String? = nil, model: String? = nil) -> AsyncThrowingStream<String, Error> {
        let selectedModel = model ?? modelManager.selectedModel

        return AsyncThrowingStream { continuation in
            Task {
                do {
                    try await rateLimiter.waitForAvailability()

                    var messages = contextManager.getMessages()
                    if let context = context {
                        messages.append(OpenRouterModels.Message(role: "system", content: context))
                    }
                    messages.append(OpenRouterModels.Message(role: "user", content: prompt))

                    let stream = client.stream(model: selectedModel, messages: messages)
                    var fullResponse = ""

                    for try await chunk in stream {
                        fullResponse += chunk
                        continuation.yield(chunk)
                    }

                    contextManager.addMessage(OpenRouterModels.Message(role: "user", content: prompt))
                    contextManager.addMessage(OpenRouterModels.Message(role: "assistant", content: fullResponse))
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: errorHandler.handle(error))
                }
            }
        }
    }
}
