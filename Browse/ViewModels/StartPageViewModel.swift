import SwiftUI
import Observation

@Observable
final class StartPageViewModel {
    var topSites: [URL] = [
        URL(string: "https://www.google.com")!,
        URL(string: "https://www.apple.com")!,
        URL(string: "https://www.github.com")!
    ]

    var showRecentTabs: Bool = true
    var showTopSites: Bool = true
}
