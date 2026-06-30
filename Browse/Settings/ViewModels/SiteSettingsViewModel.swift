import Foundation
import Observation

@Observable
final class SiteSettingsViewModel {
    private let manager = SiteSettingsManager.shared

    var currentSettings: SiteSettings?

    func loadSettings(for host: String) {
        currentSettings = manager.getSettings(for: host)
    }

    func updateZoom(_ level: Double) {
        currentSettings?.zoomLevel = level
        manager.saveSettings()
    }

    func toggleDarkMode() {
        currentSettings?.isDarkModeEnabled.toggle()
        manager.saveSettings()
    }
}
