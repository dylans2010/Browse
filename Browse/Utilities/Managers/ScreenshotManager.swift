import Foundation
import WebKit
import SwiftUI

#if os(macOS)
import AppKit
typealias PlatformImage = NSImage
#else
import UIKit
typealias PlatformImage = UIImage
#endif

@Observable
final class ScreenshotManager {
    static let shared = ScreenshotManager()

    /// Captures a screenshot of the visible area of a WKWebView.
    func captureVisibleArea(from webView: WKWebView) async -> PlatformImage? {
        let configuration = WKSnapshotConfiguration()
        #if os(macOS)
        return try? await webView.takeSnapshot(configuration: configuration)
        #else
        return try? await webView.takeSnapshot(configuration: configuration)
        #endif
    }

    /// Captures a full-page screenshot of a WKWebView.
    func captureFullPage(from webView: WKWebView) async -> PlatformImage? {
        let configuration = WKSnapshotConfiguration()
        configuration.afterScreenUpdates = true
        return try? await webView.takeSnapshot(configuration: configuration)
    }
}
