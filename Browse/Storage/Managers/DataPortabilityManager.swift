import Foundation
import SwiftData

final class DataPortabilityManager {
    static let shared = DataPortabilityManager()
    private let context = PersistenceProvider.shared.mainContext

    struct ExportData: Codable {
        let history: [HistoryEntry]
        let bookmarks: [BookmarkEntry]

        struct HistoryEntry: Codable {
            let url: URL
            let title: String
            let visitCount: Int
        }

        struct BookmarkEntry: Codable {
            let url: URL
            let title: String
        }
    }

    /// Exports browser data to a JSON file.
    func exportData() async throws -> URL {
        let historyDescriptor = FetchDescriptor<HistoryItem>()
        let history = (try? context.fetch(historyDescriptor)) ?? []

        let bookmarkDescriptor = FetchDescriptor<Bookmark>()
        let bookmarks = (try? context.fetch(bookmarkDescriptor)) ?? []

        let export = ExportData(
            history: history.map { ExportData.HistoryEntry(url: $0.url, title: $0.title, visitCount: $0.visitCount) },
            bookmarks: bookmarks.map { ExportData.BookmarkEntry(url: $0.url, title: $0.title) }
        )

        let data = try JSONEncoder().encode(export)
        let exportURL = FileManager.default.temporaryDirectory.appendingPathComponent("BrowseExport.json")
        try data.write(to: exportURL)
        return exportURL
    }

    /// Imports browser data from a JSON file.
    func importData(from url: URL) async throws {
        let data = try Data(contentsOf: url)
        let export = try JSONDecoder().decode(ExportData.self, data: data)

        for entry in export.history {
            let item = HistoryItem(url: entry.url, title: entry.title, profileId: UUID())
            context.insert(item)
        }

        for entry in export.bookmarks {
            let item = Bookmark(url: entry.url, title: entry.title)
            context.insert(item)
        }

        try? context.save()
    }
}
