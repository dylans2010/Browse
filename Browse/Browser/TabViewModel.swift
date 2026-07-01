import Foundation
import Observation

@Observable
final class TabViewModel {
    private let logicManager = TabLogicManager.shared
    private let tabManager = TabManager() // This would normally be injected or shared

    var tabs: [TabManager.Tab] { tabManager.tabs }

    func cleanupDuplicates() {
        let tabItems = tabs.map { $0.item }
        let duplicates = logicManager.findDuplicates(in: tabItems)
        for dup in duplicates {
            tabManager.closeTab(id: dup.id)
        }
    }

    func runAutoArchive() {
        let tabItems = tabs.map { $0.item }
        logicManager.archiveInactiveTabs(in: tabItems)
    }
}
