import Foundation
import Observation

@Observable
final class ExtensionGenerator {
    static let shared = ExtensionGenerator()
    private let aiService = AIService.shared

    struct ExtensionResult: Codable {
        let name: String
        let script: String
        let manifest: String
    }

    /// Generates a browser extension from a natural language description using AI.
    func generateExtension(from description: String) async throws -> ExtensionResult {
        let prompt = """
        Generate a production-ready browser extension based on this description: "\(description)".
        Return a JSON object with the following fields:
        "name": The name of the extension.
        "script": The complete JavaScript source code.
        "manifest": A valid Manifest V3 JSON string.
        Ensure the response is ONLY the JSON object.
        """

        let response = try await aiService.complete(prompt: prompt)

        guard let data = response.data(using: .utf8) else {
            throw AIError.invalidResponse
        }

        return try JSONDecoder().decode(ExtensionResult.self, from: data)
    }
}
