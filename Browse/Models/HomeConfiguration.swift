import Foundation
import SwiftData

@Model
final class HomeConfiguration {
    var id: UUID
    var profileId: UUID
    var backgroundType: String // "solid", "gradient", "image", "glass", "acrylic"
    var backgroundColor: String
    var backgroundImagePath: String?
    var blurIntensity: Double
    var showPinnedSites: Bool
    var showRecentPages: Bool
    var showAIShortcuts: Bool
    var showQuickSearch: Bool

    init(profileId: UUID) {
        self.id = UUID()
        self.profileId = profileId
        self.backgroundType = "glass"
        self.backgroundColor = "system"
        self.blurIntensity = 20.0
        self.showPinnedSites = true
        self.showRecentPages = true
        self.showAIShortcuts = true
        self.showQuickSearch = true
    }
}
