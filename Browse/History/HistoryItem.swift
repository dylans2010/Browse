import Foundation
import SwiftData

@Model
final class HistoryItem {
    var url: URL
    var title: String
    var timestamp: Date
    var visitCount: Int
    var profileId: UUID

    init(url: URL, title: String, profileId: UUID) {
        self.url = url
        self.title = title
        self.timestamp = Date()
        self.visitCount = 1
        self.profileId = profileId
    }
}
