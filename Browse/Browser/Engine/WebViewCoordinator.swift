import Foundation
import WebKit

final class WebViewCoordinator: NSObject, WKScriptMessageHandler {
    private let tabID: UUID
    private weak var tabManager: TabManager?

    init(tabID: UUID, tabManager: TabManager) {
        self.tabID = tabID
        self.tabManager = tabManager
        super.init()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "audioActivityBridge", let isPlaying = message.body as? Bool {
            Task { @MainActor in
                tabManager?.updateAudioState(for: tabID, isPlaying: isPlaying)
            }
        }
    }
}
