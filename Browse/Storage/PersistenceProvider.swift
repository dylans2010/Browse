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
            DownloadItem.self
        ])

        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not initialize SwiftData container: \(error)")
        }
    }

    var mainContext: ModelContext {
        container.mainContext
    }
}
