import Foundation

final class AIContextManager {
    private var messages: [OpenRouterModels.Message] = []
    private let maxMessages = 20

    func addMessage(_ message: OpenRouterModels.Message) {
        messages.append(message)
        if messages.count > maxMessages {
            messages.removeFirst()
        }
    }

    func getMessages() -> [OpenRouterModels.Message] {
        return messages
    }

    func clear() {
        messages.removeAll()
    }
}
