import XCTest

final class BrowseUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.exists)
    }
}
