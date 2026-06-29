import Foundation
import SwiftData

@Model
final class Bookmark {
    var url: URL
    var title: String
    var folder: String?
    var tags: [String]
    var createdAt: Date
    var profileId: UUID
    var isFavorite: Bool

    init(url: URL, title: String, profileId: UUID, folder: String? = nil, tags: [String] = [], isFavorite: Bool = false) {
        self.url = url
        self.title = title
        self.profileId = profileId
        self.folder = folder
        self.tags = tags
        self.createdAt = Date()
        self.isFavorite = isFavorite
    }
}
