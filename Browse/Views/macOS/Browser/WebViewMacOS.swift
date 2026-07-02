#if os(macOS)
import SwiftUI
import AppKit
import WebKit

struct WebViewMacOS: NSViewRepresentable {
    let webView: WKWebView
    var customCSS: String?
    var customJS: String?

    func makeNSView(context: Context) -> WKWebView { return webView }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let css = customCSS {
            let script = """
            (function() {
                var style = document.getElementById('browse-custom-css');
                if (!style) {
                    style = document.createElement('style');
                    style.id = 'browse-custom-css';
                    document.head.appendChild(style);
                }
                style.textContent = `\(css.replacingOccurrences(of: "`", with: "\\`"))`;
            })();
            """
            nsView.evaluateJavaScript(script)
        }

        if let js = customJS {
            nsView.evaluateJavaScript(js)
        }
    }
}
#endif
