import Foundation
import Observation

@Observable
final class ReadingListViewModel {
    private let manager = ReadingListManager.shared

    var items: [ReadingListItem] { manager.items }

    func loadItems() {
        manager.fetchItems()
    }

    func add(url: URL, title: String) {
        manager.addItem(url: url, title: title)
    }

    func toggleRead(_ item: ReadingListItem) {
        manager.updateItem(item, isRead: !item.isRead)
    }

    func remove(_ item: ReadingListItem) {
        manager.deleteItem(item)
    }
}
