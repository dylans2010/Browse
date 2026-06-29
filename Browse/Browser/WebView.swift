import SwiftUI
import WebKit

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#else
typealias ViewRepresentable = UIViewRepresentable
#endif

struct WebView: ViewRepresentable {
    let webView: WKWebView

    #if os(macOS)
    func makeNSView(context: Context) -> WKWebView { return webView }
    func updateNSView(_ nsView: WKWebView, context: Context) {}
    #else
    func makeUIView(context: Context) -> WKWebView { return webView }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    #endif
}

@Observable
final class WebPageManager: NSObject, WKNavigationDelegate, WKUIDelegate {
    let webView: WKWebView
    var url: URL?
    var title: String = ""
    var isLoading: Bool = false
    var estimatedProgress: Double = 0.0
    var canGoBack: Bool = false
    var canGoForward: Bool = false
    var isReaderAvailable: Bool = false

    var onURLChange: ((URL, String) -> Void)?

    override init() {
        let config = WKWebViewConfiguration()
        let pool = WKProcessPool()
        config.processPool = pool

        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs

        self.webView = WKWebView(frame: .zero, configuration: config)
        super.init()
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self

        setupObservers()
    }

    private func setupObservers() {
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "isLoading", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "canGoForward", options: .new, context: nil)
    }

    func load(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func goBack() { webView.goBack() }
    func goForward() { webView.goForward() }
    func reload() { webView.reload() }
    func stopLoading() { webView.stopLoading() }

    func getPageContent() async throws -> String {
        let script = "document.body.innerText"
        return try await webView.evaluateJavaScript(script) as? String ?? ""
    }

    func injectCustomStyles(css: String) async {
        let script = """
        var style = document.getElementById('browse-custom-style');
        if (!style) {
            style = document.createElement('style');
            style.id = 'browse-custom-style';
            document.head.appendChild(style);
        }
        style.innerHTML = `\(css)`;
        """
        try? await webView.evaluateJavaScript(script)
    }

    func injectCustomScript(js: String) async {
        try? await webView.evaluateJavaScript(js)
    }

    // MARK: - Extension Runtime
    func runExtension(_ ext: BrowserExtension) async {
        guard ext.isActive else { return }

        // Secure communication bridge for extensions
        let bridgeScript = """
        window.browse = {
            postMessage: function(msg) {
                window.webkit.messageHandlers.browseBridge.postMessage(msg);
            }
        };
        """
        try? await webView.evaluateJavaScript(bridgeScript)

        // Basic sandboxing by wrapping in an IIFE
        let sandboxedScript = """
        (function(browse) {
            try {
                \(ext.scriptJS)
            } catch (e) {
                console.error('Extension Error (\(ext.name)):', e);
            }
        })(window.browse);
        """
        try? await webView.evaluateJavaScript(sandboxedScript)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            switch keyPath {
            case "estimatedProgress": self.estimatedProgress = self.webView.estimatedProgress
            case "title": self.title = self.webView.title ?? ""
            case "URL":
                self.url = self.webView.url
                if let url = self.url {
                    self.onURLChange?(url, self.title)
                }
            case "isLoading":
                self.isLoading = self.webView.isLoading
                if !self.isLoading {
                    self.isReaderAvailable = true // Simplified detection

                    // Run active extensions when page finishes loading
                    Task {
                        let activeExtensions = ExtensionManager.shared.extensions.filter { $0.isActive }
                        for ext in activeExtensions {
                            await self.runExtension(ext)
                        }
                    }
                }
            case "canGoBack": self.canGoBack = self.webView.canGoBack
            case "canGoForward": self.canGoForward = self.webView.canGoForward
            default: super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "URL")
        webView.removeObserver(self, forKeyPath: "isLoading")
        webView.removeObserver(self, forKeyPath: "canGoBack")
        webView.removeObserver(self, forKeyPath: "canGoForward")
    }
}
