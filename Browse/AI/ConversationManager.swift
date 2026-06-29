import Foundation
import Observation

/// Manages AI conversations and history.
@Observable
final class ConversationManager {
    var messages: [OpenRouterModels.Message] = []

    func addMessage(_ message: OpenRouterModels.Message) {
        messages.append(message)
    }

    func clear() {
        messages.removeAll()
    }
}
