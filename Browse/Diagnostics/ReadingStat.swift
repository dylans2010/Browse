import Foundation
import SwiftData

@Model
final class ReadingStat {
    var id: UUID
    var host: String
    var timeSpent: TimeInterval
    var lastVisited: Date

    init(host: String, timeSpent: TimeInterval = 0) {
        self.id = UUID()
        self.host = host
        self.timeSpent = timeSpent
        self.lastVisited = Date()
    }
}
