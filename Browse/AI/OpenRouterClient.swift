import Foundation

/// Client for interacting with the OpenRouter API.
final class OpenRouterClient {
    private let baseURL = URL(string: "https://openrouter.ai/api/v1")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    private var apiKey: String? {
        try? KeychainManager.shared.retrieve(for: "OpenRouterAPIKey")
    }

    func complete(model: String, messages: [OpenRouterModels.Message]) async throws -> String {
        guard let apiKey = apiKey else { throw AIError.missingAPIKey }

        var request = URLRequest(url: baseURL.appendingPathComponent("chat/completions"))
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Browse/1.0", forHTTPHeaderField: "X-Title")

        let body = OpenRouterModels.ChatCompletionRequest(model: model, messages: messages, stream: false)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw AIError.requestFailed
        }

        let decoded = try JSONDecoder().decode(OpenRouterModels.ChatCompletionResponse.self, from: data)
        return decoded.choices.first?.message.content ?? ""
    }

    func stream(model: String, messages: [OpenRouterModels.Message]) -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                guard let apiKey = apiKey else {
                    continuation.finish(throwing: AIError.missingAPIKey)
                    return
                }

                var request = URLRequest(url: baseURL.appendingPathComponent("chat/completions"))
                request.httpMethod = "POST"
                request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Browse/1.0", forHTTPHeaderField: "X-Title")

                let body = OpenRouterModels.ChatCompletionRequest(model: model, messages: messages, stream: true)
                request.httpBody = try JSONEncoder().encode(body)

                do {
                    let (bytes, response) = try await session.bytes(for: request)

                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        continuation.finish(throwing: AIError.requestFailed)
                        return
                    }

                    for try await line in bytes.lines {
                        if line.hasPrefix("data: ") {
                            let jsonString = String(line.dropFirst(6)).trimmingCharacters(in: .whitespaces)
                            if jsonString == "[DONE]" {
                                continuation.finish()
                                return
                            }

                            if let data = jsonString.data(using: .utf8),
                               let chunk = try? JSONDecoder().decode(OpenRouterModels.ChatCompletionChunk.self, from: data),
                               let content = chunk.choices.first?.delta.content {
                                continuation.yield(content)
                            }
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

enum AIError: Error {
    case missingAPIKey
    case requestFailed
    case invalidResponse
}

/// Models for OpenRouter API requests and responses.
enum OpenRouterModels {
    struct Message: Codable {
        let role: String
        let content: String
    }

    struct ChatCompletionRequest: Codable {
        let model: String
        let messages: [Message]
        var stream: Bool = false
    }

    struct ChatCompletionResponse: Codable {
        struct Choice: Codable {
            let message: Message
        }
        let choices: [Choice]
    }

    struct ChatCompletionChunk: Codable {
        struct Choice: Codable {
            struct Delta: Codable {
                let content: String?
            }
            let delta: Delta
        }
        let choices: [Choice]
    }
}
