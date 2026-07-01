import Foundation
import WebKit

@Observable
final class SecurityManager {
    static let shared = SecurityManager()

    /// Fetches cookies for a given web view.
    func fetchCookies(from webView: WKWebView) async -> [HTTPCookie] {
        await withCheckedContinuation { continuation in
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                continuation.resume(returning: cookies)
            }
        }
    }

    /// Fetches website storage data types.
    func fetchWebsiteData(from webView: WKWebView) async -> [WKWebsiteDataRecord] {
        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        return await withCheckedContinuation { continuation in
            webView.configuration.websiteDataStore.fetchDataRecords(ofTypes: dataTypes) { records in
                continuation.resume(returning: records)
            }
        }
    }
}
