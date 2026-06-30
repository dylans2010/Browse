import Foundation
import SwiftData

@Model
final class HomepageConfig {
    var id: UUID
    var profileId: UUID
    var backgroundImageURL: URL?
    var widgets: [String] // e.g., "top_sites", "weather", "news"
    var layout: String // "centered", "grid"

    init(profileId: UUID, widgets: [String] = ["top_sites"], layout: String = "centered") {
        self.id = UUID()
        self.profileId = profileId
        self.widgets = widgets
        self.layout = layout
    }
}
