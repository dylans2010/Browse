import Foundation
import WebKit

@Observable
final class PageInfoManager: NSObject {
    static let shared = PageInfoManager()

    struct PageInfo {
        let title: String
        let url: URL
        let serverTrust: SecTrust?
        let certificateInfo: String?
    }

    func getPageInfo(from webView: WKWebView) async -> PageInfo {
        let title = await webView.title ?? ""
        let url = await webView.url ?? URL(string: "about:blank")!
        let serverTrust = await webView.serverTrust

        var certificateInfo: String? = nil
        if let trust = serverTrust {
            if let certificate = SecTrustGetCertificateAtIndex(trust, 0) {
                certificateInfo = SecCertificateCopySubjectSummary(certificate) as String?
            }
        }

        return PageInfo(title: title, url: url, serverTrust: serverTrust, certificateInfo: certificateInfo)
    }
}
