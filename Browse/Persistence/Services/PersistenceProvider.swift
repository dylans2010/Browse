import Foundation
import SwiftData

/// Provides and manages the SwiftData model container.
final class PersistenceProvider {
    static let shared = PersistenceProvider()

    let container: ModelContainer

    private init() {
        let schema = Schema([
            HistoryItem.self,
            Bookmark.self,
            TabItem.self,
            Profile.self,
            DownloadItem.self,
            Workspace.self,
            SessionSnapshot.self,
            TabItemSnapshot.self,
            SitePermission.self,
            SiteSettings.self,
            ReadingStat.self,
            WebsiteNote.self,
            ReadingListItem.self,
            UIConfiguration.self,
            HomepageConfig.self,
            KeyboardShortcut.self,
            GestureCommand.self,
            Theme.self,
            CustomSiteConfig.self,
            BrowserExtension.self,
            HomeConfiguration.self
        ])

        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not initialize SwiftData container: \(error)")
        }
    }

    var mainContext: ModelContext {
        MainActor.assumeIsolated {
            container.mainContext
        }
    }
}
