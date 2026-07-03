import Foundation
import Observation

@MainActor
@Observable
final class ToolsMenuMacOSViewModel {
    private let bookmarkManager = BookmarkManager.shared
    private let commandManager = CommandManager.shared

    var isCurrentSiteFavorited: Bool = false

    func checkFavoriteStatus(for url: URL?, profileId: UUID) {
        guard let url = url else {
            isCurrentSiteFavorited = false
            return
        }
        isCurrentSiteFavorited = bookmarkManager.favorites().contains(where: { $0.url == url })
    }

    func toggleFavorite(for tab: TabManager.TabWrapper) {
        guard let url = tab.webPage.url else { return }
        bookmarkManager.toggleFavorite(url: url, title: tab.webPage.title, profileId: tab.item.profileId)
        isCurrentSiteFavorited.toggle()
    }

    func invoke(command: String) {
        if let action = CommandManager.shared.matchCommand(command) {
            action()
        }
    }
}
