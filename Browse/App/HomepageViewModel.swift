import Foundation
import Observation

@Observable
final class HomepageViewModel {
    private let manager = HomepageManager.shared

    var currentConfig: HomepageConfig?

    func loadConfig(for profileId: UUID) {
        currentConfig = manager.getConfig(for: profileId)
    }

    func addWidget(_ widget: String) {
        currentConfig?.widgets.append(widget)
        manager.saveConfig()
    }
}
