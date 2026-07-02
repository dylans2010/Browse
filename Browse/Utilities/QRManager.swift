import Foundation
import CoreImage.CIFilterBuiltins
import SwiftUI

#if os(macOS)
import AppKit
#endif

#if !os(macOS)
import UIKit
#endif

final class QRManager {
    static let shared = QRManager()

    /// Generates a QR code image for a given string.
    func generateQRCode(from string: String) -> PlatformImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                #if os(macOS)
                return NSImage(cgImage: cgimg, size: NSSize(width: outputImage.extent.width, height: outputImage.extent.height))
                #else
                return UIImage(cgImage: cgimg)
                #endif
            }
        }
        return nil
    }
}
