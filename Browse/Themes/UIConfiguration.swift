import Foundation
import SwiftData

@Model
final class UIConfiguration {
    var id: UUID
    var profileId: UUID
    var toolbarItems: [String]
    var sidebarItems: [String]
    var isSidebarPinned: Bool

    // Sidebar Personalization
    var sidebarWidth: Double
    var sidebarCollapsedWidth: Double
    var sidebarIconSize: Double
    var sidebarSpacing: Double
    var sidebarMaterial: String // "glass", "acrylic", "solid"
    var accentColor: String
    var useVerticalTabs: Bool

    init(profileId: UUID, toolbarItems: [String] = ["back", "forward", "reload", "address"], sidebarItems: [String] = ["tabs", "bookmarks", "history"], isSidebarPinned: Bool = true) {
        self.id = UUID()
        self.profileId = profileId
        self.toolbarItems = toolbarItems
        self.sidebarItems = sidebarItems
        self.isSidebarPinned = isSidebarPinned
        self.sidebarWidth = 250.0
        self.sidebarCollapsedWidth = 50.0
        self.sidebarIconSize = 18.0
        self.sidebarSpacing = 8.0
        self.sidebarMaterial = "glass"
        self.accentColor = "blue"
        self.useVerticalTabs = true
    }
}
