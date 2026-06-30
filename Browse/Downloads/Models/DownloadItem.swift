import Foundation
import SwiftData

@Model
final class DownloadItem {
    var id: UUID
    var url: URL
    var filename: String
    var totalBytes: Int64
    var receivedBytes: Int64
    var status: String // "downloading", "paused", "completed", "failed", "cancelled"
    var createdAt: Date
    var finishedAt: Date?
    var profileId: UUID
    var localPath: String?

    init(url: URL, filename: String, profileId: UUID, totalBytes: Int64 = 0) {
        self.id = UUID()
        self.url = url
        self.filename = filename
        self.profileId = profileId
        self.totalBytes = totalBytes
        self.receivedBytes = 0
        self.status = "downloading"
        self.createdAt = Date()
    }
}
