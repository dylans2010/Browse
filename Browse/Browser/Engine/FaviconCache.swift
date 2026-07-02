import Foundation
import AppKit
import WebKit

actor FaviconCache {
    static let shared = FaviconCache()

    private var cache: [String: Data] = [:]

    func favicon(for domain: String) async -> Data? {
        return cache[domain]
    }

    func prefetch(for webView: WKWebView, domain: String) async {
        // Real discovery logic: query link[rel*="icon"]
        let script = """
        (function() {
            var icon = document.querySelector('link[rel*="icon"]');
            return icon ? icon.href : null;
        })();
        """

        guard let iconURLString = try? await webView.evaluateJavaScript(script) as? String,
              let iconURL = URL(string: iconURLString) else {
            return
        }

        if let (data, _) = try? await URLSession.shared.data(from: iconURL) {
            cache[domain] = data
        }
    }

    func store(_ data: Data, for domain: String) {
        cache[domain] = data
    }
}
