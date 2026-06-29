import XCTest
@testable import Browse

final class AIServiceTests: XCTestCase {
    func testPromptBuilding() {
        let content = "Hello world"
        let prompt = PromptBuilder.build(.summarize(content: content))
        XCTAssertTrue(prompt.contains(content))
        XCTAssertTrue(prompt.contains("summary"))
    }

    func testConversationManager() {
        let manager = ConversationManager()
        let message = OpenRouterModels.Message(role: "user", content: "Hi")
        manager.addMessage(message)
        XCTAssertEqual(manager.messages.count, 1)
        XCTAssertEqual(manager.messages.first?.content, "Hi")

        manager.clear()
        XCTAssertEqual(manager.messages.count, 0)
    }
}
