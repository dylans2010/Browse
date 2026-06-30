import Foundation
import Observation
import SwiftUI

@Observable
final class ScreenshotViewModel {
    private let manager = ScreenshotManager.shared

    var capturedImage: PlatformImage?

    func captureVisible(from webView: Any) async {
        if let wkWebView = webView as? WKWebView {
            capturedImage = await manager.captureVisibleArea(from: wkWebView)
        }
    }

    func captureFull(from webView: Any) async {
        if let wkWebView = webView as? WKWebView {
            capturedImage = await manager.captureFullPage(from: wkWebView)
        }
    }
}
