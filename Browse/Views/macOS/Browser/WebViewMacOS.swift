import SwiftUI
import WebKit

struct WebViewMacOS: NSViewRepresentable {
    let webView: WKWebView

    func makeNSView(context: Context) -> WKWebView { return webView }
    func updateNSView(_ nsView: WKWebView, context: Context) {}
}
