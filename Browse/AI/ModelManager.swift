import Foundation
import Observation

/// Manages available and preferred AI models.
@Observable
final class ModelManager {
    var availableModels: [String] = [
        "openai/gpt-3.5-turbo",
        "openai/gpt-4-turbo",
        "anthropic/claude-3-opus",
        "anthropic/claude-3-sonnet",
        "google/gemini-pro-1.5",
        "meta-llama/llama-3-70b-instruct"
    ]

    var selectedModel: String = "openai/gpt-3.5-turbo"
}
