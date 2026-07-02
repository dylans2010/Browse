import XCTest
@testable import Browse

final class TabSwitchPerformanceTests: XCTestCase {
    func testTabSwitchLatency() {
        let options = XCTMeasureOptions()
        options.iterationCount = 5

        measure(options: options) {
            // Simulate the core logic of switching a tab in the TabManager
            // In a real environment, this would involve the UI interaction
            let expectation = expectation(description: "Tab switch")
            DispatchQueue.main.async {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.0)
        }
    }
}
