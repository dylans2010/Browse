import XCTest
@testable import Browse

final class NetworkingTests: XCTestCase {
    func testSearchURLBuilding() {
        let manager = SearchProviderManager.shared
        let query = "apple"
        let url = manager.searchURL(for: query)
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.absoluteString.contains("apple") ?? false)
    }
}
