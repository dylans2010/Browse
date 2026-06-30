import Foundation
import SwiftData
import Observation

@Observable
final class ReadingListManager {
    static let shared = ReadingListManager()
    private let context = PersistenceProvider.shared.mainContext

    var items: [ReadingListItem] = []

    func fetchItems() {
        let descriptor = FetchDescriptor<ReadingListItem>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        items = (try? context.fetch(descriptor)) ?? []
    }

    func addItem(url: URL, title: String) {
        let item = ReadingListItem(url: url, title: title)
        context.insert(item)
        try? context.save()
        fetchItems()
    }
}
