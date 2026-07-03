import SwiftUI
import Observation
import WebKit

@Observable
@MainActor
final class WebPageManager: NSObject, WKNavigationDelegate, WKUIDelegate {
    nonisolated let webView: WKWebView
    var url: URL?
    var title: String = ""
    var isLoading: Bool = false
    var estimatedProgress: Double = 0.0
    var canGoBack: Bool = false
    var canGoForward: Bool = false
    var isReaderAvailable: Bool = false

    var onURLChange: ((URL, String) -> Void)?
    nonisolated private let tabID: UUID
    private weak var tabManager: TabManager?
    private var coordinator: WebViewCoordinator?

    init(tabID: UUID, webView: WKWebView, tabManager: TabManager) {
        self.tabID = tabID
        self.webView = webView
        self.tabManager = tabManager
        super.init()

        self.coordinator = WebViewCoordinator(tabID: tabID, tabManager: tabManager)

        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self

        setupConfiguration()
        setupObservers()
    }

    private func setupConfiguration() {
        webView.configuration.userContentController.add(coordinator!, name: "audioActivityBridge")
        webView.configuration.userContentController.addUserScript(UserScriptLibrary.shared.audioActivityScript)
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

    func getPageContent() async throws -> String {
        let script = "document.body.innerText"
        let result = try await webView.evaluateJavaScript(script)
        return result as? String ?? ""
    }

    nonisolated override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress", "title", "URL", "isLoading", "canGoBack", "canGoForward":
            Task { @MainActor in
                switch keyPath {
                case "estimatedProgress":
                    self.estimatedProgress = self.webView.estimatedProgress
                    self.tabManager?.updateLoadingState(for: self.tabID, isLoading: self.webView.isLoading, progress: self.webView.estimatedProgress)
                case "title":
                    self.title = self.webView.title ?? ""
                    self.tabManager?.updateTitle(for: self.tabID, title: self.title)
                case "URL":
                    self.url = self.webView.url
                    if let url = self.url {
                        self.onURLChange?(url, self.title)
                        await FaviconCache.shared.prefetch(for: self.webView, domain: url.host ?? "")
                        if let data = await FaviconCache.shared.favicon(for: url.host ?? "") {
                            self.tabManager?.updateFavicon(for: self.tabID, data: data)
                        }
                    }
                case "isLoading":
                    self.isLoading = self.webView.isLoading
                    self.tabManager?.updateLoadingState(for: self.tabID, isLoading: self.isLoading, progress: self.estimatedProgress)
                    if !self.isLoading {
                        self.isReaderAvailable = true
                    }
                case "canGoBack": self.canGoBack = self.webView.canGoBack
                case "canGoForward": self.canGoForward = self.webView.canGoForward
                default: break
                }
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "audioActivityBridge")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "URL")
        webView.removeObserver(self, forKeyPath: "isLoading")
        webView.removeObserver(self, forKeyPath: "canGoBack")
        webView.removeObserver(self, forKeyPath: "canGoForward")
    }
}
