import Foundation
import Observation

/// Handles streaming state and updates for AI responses.
@Observable
final class StreamingManager {
    var currentResponse: String = ""
    var isStreaming: Bool = false

    func reset() {
        currentResponse = ""
        isStreaming = false
    }

    func append(_ text: String) {
        currentResponse += text
    }
}
