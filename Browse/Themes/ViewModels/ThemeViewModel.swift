import Foundation
import Observation

@Observable
final class ThemeViewModel {
    private let manager = ThemeManager.shared

    var currentConfig: UIConfiguration?

    func loadConfig(for profileId: UUID) {
        currentConfig = manager.getConfiguration(for: profileId)
    }

    func updateToolbar(items: [String]) {
        currentConfig?.toolbarItems = items
        manager.saveConfiguration()
    }
}
