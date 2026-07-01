import Foundation
import Observation

@Observable
final class CustomSiteViewModel {
    private let manager = CustomSiteManager.shared

    var currentConfig: CustomSiteConfig?

    func loadConfig(for host: String) {
        currentConfig = manager.getConfig(for: host)
    }

    func updateCSS(_ css: String) {
        currentConfig?.customCSS = css
        // Logic to sync visual editor properties from CSS could go here
        manager.saveConfig()
    }

    func updateJS(_ js: String) {
        currentConfig?.customJS = js
        manager.saveConfig()
    }

    func updateVisualProperty(typography: String? = nil, accentColor: String? = nil) {
        if let typography = typography {
            currentConfig?.typography = typography
        }
        if let accentColor = accentColor {
            currentConfig?.accentColor = accentColor
        }

        // Sync CSS from visual properties
        let generatedCSS = """
        body {
            font-family: \(currentConfig?.typography ?? "system-ui") !important;
            --browse-accent-color: \(currentConfig?.accentColor ?? "blue");
        }
        """
        currentConfig?.customCSS = generatedCSS
        manager.saveConfig()
    }
}
