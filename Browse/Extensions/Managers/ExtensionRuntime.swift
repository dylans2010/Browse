import Foundation
import WebKit

final class ExtensionRuntime {
    static let shared = ExtensionRuntime()
    private let extensionManager = ExtensionManager.shared

    /// Injects all enabled extensions into the provided web view.
    func injectExtensions(into webView: WKWebView) {
        extensionManager.fetchExtensions()
        let enabledExtensions = extensionManager.extensions.filter { $0.isEnabled }

        for ext in enabledExtensions {
            let userScript = WKUserScript(
                source: ext.scriptSource,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: false
            )
            webView.configuration.userContentController.addUserScript(userScript)
        }
    }

    /// Clears all injected scripts from the web view.
    func clearExtensions(from webView: WKWebView) {
        webView.configuration.userContentController.removeAllUserScripts()
    }
}
