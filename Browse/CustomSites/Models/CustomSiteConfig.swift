import Foundation
import SwiftData

@Model
final class CustomSiteConfig {
    var id: UUID
    var host: String
    var customCSS: String
    var customJS: String
    var typography: String
    var accentColor: String
    var isEnabled: Bool

    init(host: String, customCSS: String = "", customJS: String = "", typography: String = "system", accentColor: String = "blue", isEnabled: Bool = true) {
        self.id = UUID()
        self.host = host
        self.customCSS = customCSS
        self.customJS = customJS
        self.typography = typography
        self.accentColor = accentColor
        self.isEnabled = isEnabled
    }
}
