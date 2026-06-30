import Foundation
import SwiftData

@Model
final class SitePermission {
    var id: UUID
    var host: String
    var permissionType: String // e.g., "camera", "microphone", "location"
    var state: String // e.g., "allowed", "denied", "ask"

    init(host: String, permissionType: String, state: String = "ask") {
        self.id = UUID()
        self.host = host
        self.permissionType = permissionType
        self.state = state
    }
}
