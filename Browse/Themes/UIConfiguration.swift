import Foundation
import SwiftData

@Model
final class UIConfiguration {
    var id: UUID
    var profileId: UUID
    var toolbarItems: [String]
    var sidebarItems: [String]
    var isSidebarPinned: Bool

    init(profileId: UUID, toolbarItems: [String] = ["back", "forward", "reload", "address"], sidebarItems: [String] = ["tabs", "bookmarks", "history"], isSidebarPinned: Bool = true) {
        self.id = UUID()
        self.profileId = profileId
        self.toolbarItems = toolbarItems
        self.sidebarItems = sidebarItems
        self.isSidebarPinned = isSidebarPinned
    }
}
