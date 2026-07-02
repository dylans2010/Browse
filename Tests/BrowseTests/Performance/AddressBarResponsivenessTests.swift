import XCTest
@testable import Browse

final class AddressBarResponsivenessTests: XCTestCase {
    func testAddressBarDebounce() {
        let expectation = expectation(description: "Debounce completes")

        let startTime = Date()
        Task {
            try? await Task.sleep(nanoseconds: 250_000_000)
            let duration = Date().timeIntervalSince(startTime)
            XCTAssertGreaterThanOrEqual(duration, 0.25)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
