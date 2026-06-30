import Foundation
import Observation
import WebKit

@Observable
final class SecurityViewModel {
    private let manager = SecurityManager.shared

    var cookies: [HTTPCookie] = []
    var dataRecords: [WKWebsiteDataRecord] = []

    func refresh(webView: WKWebView) async {
        cookies = await manager.fetchCookies(from: webView)
        dataRecords = await manager.fetchWebsiteData(from: webView)
    }
}
