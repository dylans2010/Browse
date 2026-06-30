import Foundation
import Observation
import WebKit

@Observable
final class PageInfoViewModel {
    private let manager = PageInfoManager.shared

    var pageInfo: PageInfoManager.PageInfo?

    func update(webView: WKWebView) async {
        pageInfo = await manager.getPageInfo(from: webView)
    }
}
