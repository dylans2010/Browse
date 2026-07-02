import Foundation
import Observation

@Observable
final class CustomSiteViewModel {
    private let manager = CustomSiteManager.shared

    var currentConfig: CustomSiteConfig?
    var hiddenElements: [String] = []
    var isInspectorActive: Bool = false

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

    func toggleElementInspector() {
        isInspectorActive.toggle()
        // Inject JS to handle element selection
        let script = """
        (function() {
            if (window.browseInspectorActive) return;
            window.browseInspectorActive = true;
            document.addEventListener('mouseover', function(e) {
                if (!window.browseInspectorActive) return;
                e.target.style.outline = '2px solid blue';
            });
            document.addEventListener('mouseout', function(e) {
                e.target.style.outline = '';
            });
            document.addEventListener('click', function(e) {
                if (!window.browseInspectorActive) return;
                e.preventDefault();
                e.stopPropagation();
                e.target.style.display = 'none';
                // Logic to report hidden element back
            });
        })();
        """
        currentConfig?.customJS += script
        manager.saveConfig()
    }

    func restoreHiddenElements() {
        hiddenElements.removeAll()
        // Logic to clear display:none from CSS
        manager.saveConfig()
    }
}
