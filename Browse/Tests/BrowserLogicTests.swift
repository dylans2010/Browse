import XCTest
import SwiftData
@testable import Browse

@MainActor
final class BrowserLogicTests: XCTestCase {
    var context: ModelContext!
    var container: ModelContainer!

    override func setUpWithError() throws {
        let schema = Schema([
            HistoryItem.self,
            Bookmark.self,
            TabItem.self,
            Profile.self,
            DownloadItem.self,
            Workspace.self,
            SessionSnapshot.self,
            TabSnapshot.self,
            SitePermission.self,
            CustomSite.self,
            BrowserExtension.self,
            WebsiteNote.self,
            WebsiteLabel.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [config])
        context = container.mainContext
    }

    func testTabManager() throws {
        let manager = TabManager()
        let profileId = UUID()
        manager.createTab(url: URL(string: "https://apple.com"), profileId: profileId)

        XCTAssertEqual(manager.tabs.count, 1)
        XCTAssertEqual(manager.activeTab?.webPage.url?.absoluteString, "https://apple.com")

        manager.closeTab(id: manager.tabs[0].id)
        XCTAssertEqual(manager.tabs.count, 0)
    }

    func testWorkspaceManager() throws {
        let manager = WorkspaceManager.shared
        let profileId = UUID()
        manager.createWorkspace(name: "Test Workspace", profileId: profileId)

        let fetchDescriptor = FetchDescriptor<Workspace>()
        let workspaces = try context.fetch(fetchDescriptor)

        XCTAssertEqual(workspaces.count, 1)
        XCTAssertEqual(workspaces[0].name, "Test Workspace")
    }

    func testExtensionManager() throws {
        let manager = ExtensionManager.shared
        let ext = BrowserExtension(name: "Test Ext", descriptionText: "Desc", manifestJSON: "{}", scriptJS: "")
        manager.installExtension(ext)

        XCTAssertEqual(manager.extensions.count, 1)
        XCTAssertTrue(manager.extensions[0].isActive)

        manager.toggleExtension(ext)
        XCTAssertFalse(manager.extensions[0].isActive)
    }
}
