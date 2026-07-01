import Foundation
import SwiftData

@Model
final class WebsiteNote {
    var id: UUID
    var host: String
    var content: String
    var labels: [String]
    var reminderDate: Date?
    var createdAt: Date

    init(host: String, content: String, labels: [String] = [], reminderDate: Date? = nil) {
        self.id = UUID()
        self.host = host
        self.content = content
        self.labels = labels
        self.reminderDate = reminderDate
        self.createdAt = Date()
    }
}
