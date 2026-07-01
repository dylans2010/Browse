import Foundation
import SwiftData

@Model
final class SiteSettings {
    var id: UUID
    var host: String
    var zoomLevel: Double
    var isDarkModeEnabled: Bool
    var isJavaScriptEnabled: Bool
    var customUserAgent: String?

    init(host: String, zoomLevel: Double = 1.0, isDarkModeEnabled: Bool = false, isJavaScriptEnabled: Bool = true, customUserAgent: String? = nil) {
        self.id = UUID()
        self.host = host
        self.zoomLevel = zoomLevel
        self.isDarkModeEnabled = isDarkModeEnabled
        self.isJavaScriptEnabled = isJavaScriptEnabled
        self.customUserAgent = customUserAgent
    }
}
