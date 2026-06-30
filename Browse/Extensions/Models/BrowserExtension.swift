import Foundation
import SwiftData

@Model
final class BrowserExtension {
    var id: UUID
    var name: String
    var version: String
    var descriptionText: String
    var manifestJSON: String
    var scriptSource: String
    var isEnabled: Bool
    var createdAt: Date

    init(name: String, version: String = "1.0.0", descriptionText: String = "", manifestJSON: String = "{}", scriptSource: String = "", isEnabled: Bool = true) {
        self.id = UUID()
        self.name = name
        self.version = version
        self.descriptionText = descriptionText
        self.manifestJSON = manifestJSON
        self.scriptSource = scriptSource
        self.isEnabled = isEnabled
        self.createdAt = Date()
    }
}
