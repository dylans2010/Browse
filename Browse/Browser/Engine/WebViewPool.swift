import Foundation
import WebKit

@MainActor
final class WebViewPool {
    static let shared = WebViewPool()

    private var pool: [UUID: WKWebView] = [:]

    private init() {}

    func webView(for tabID: UUID, configuration: WKWebViewConfiguration) -> WKWebView {
        if let existing = pool[tabID] {
            return existing
        }

        let webView = WKWebView(frame: .zero, configuration: configuration)
        pool[tabID] = webView
        return webView
    }

    func removeWebView(for tabID: UUID) {
        pool.removeValue(forKey: tabID)
    }
}
