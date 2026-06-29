import Foundation
import Observation
import SwiftData

@Observable
final class BrowserUtilities {
    static let shared = BrowserUtilities()

    var userAgent: String = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
    var readingTime: TimeInterval = 0

    // MARK: - QR Tools
    func generateQRCode(from string: String) -> UIImage? {
        #if os(iOS)
        let data = string.data(using: .utf8)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        #endif
        return nil
    }

    // MARK: - Screenshot Tools
    func captureScreenshot(of webView: WKWebView) async -> NSImage? {
        #if os(macOS)
        let config = WKSnapshotConfiguration()
        return try? await webView.takeSnapshot(configuration: config)
        #else
        return nil
        #endif
    }

    // MARK: - Reading Statistics
    func updateReadingTime(delta: TimeInterval) {
        readingTime += delta
    }
}

#if os(iOS)
import UIKit
import CoreImage
typealias NSImage = UIImage
#else
import AppKit
#endif
