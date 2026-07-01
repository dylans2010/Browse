import SwiftUI
import WebKit

struct WebViewIOS: UIViewRepresentable {
    let webView: WKWebView

    func makeUIView(context: Context) -> WKWebView { return webView }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
