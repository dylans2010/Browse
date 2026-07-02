import Foundation
import SwiftData
import Observation

@Observable
final class BookmarkManager {
    static let shared = BookmarkManager()
    private let context = PersistenceProvider.shared.mainContext

    private init() {}

    func favorites() -> [Bookmark] {
        let fetchDescriptor = FetchDescriptor<Bookmark>(
            predicate: #Predicate { $0.isFavorite },
            sortBy: [SortDescriptor(\.favoriteSortIndex)]
        )
        return (try? context.fetch(fetchDescriptor)) ?? []
    }

    func setFavorite(_ bookmark: Bookmark, isFavorite: Bool) {
        bookmark.isFavorite = isFavorite
        try? context.save()
    }

    func toggleFavorite(url: URL, title: String, profileId: UUID) {
        let fetchDescriptor = FetchDescriptor<Bookmark>(
            predicate: #Predicate { $0.url == url && $0.profileId == profileId }
        )

        if let existing = try? context.fetch(fetchDescriptor).first {
            existing.isFavorite.toggle()
        } else {
            let newBookmark = Bookmark(url: url, title: title, profileId: profileId, isFavorite: true)
            context.insert(newBookmark)
        }
        try? context.save()
    }
}

@Observable
final class HistoryManager {
    static let shared = HistoryManager()
    private let context = PersistenceProvider.shared.mainContext

    private init() {}

    func mostVisited(limit: Int) -> [HistoryItem] {
        let fetchDescriptor = FetchDescriptor<HistoryItem>(
            sortBy: [SortDescriptor(\.visitCount, order: .reverse)]
        )
        var descriptor = fetchDescriptor
        descriptor.fetchLimit = limit
        return (try? context.fetch(descriptor)) ?? []
    }
}
