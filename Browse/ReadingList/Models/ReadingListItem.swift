import Foundation
import SwiftData

@Model
final class ReadingListItem {
    var id: UUID
    var url: URL
    var title: String
    var isRead: Bool
    var createdAt: Date

    init(url: URL, title: String, isRead: Bool = false) {
        self.id = UUID()
        self.url = url
        self.title = title
        self.isRead = isRead
        self.createdAt = Date()
    }
}
