import Foundation
import WebKit

final class BrowserEngine {
    static let shared = BrowserEngine()

    private init() {}

    func makeWebView(for tabID: UUID, configuration: WKWebViewConfiguration) async -> WKWebView {
        return await WebViewPool.shared.webView(for: tabID, configuration: configuration)
    }
}
