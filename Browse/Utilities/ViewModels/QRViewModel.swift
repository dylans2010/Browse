import Foundation
import Observation
import SwiftUI

@Observable
final class QRViewModel {
    private let manager = QRManager.shared

    var qrImage: PlatformImage?

    func generateQR(for string: String) {
        qrImage = manager.generateQRCode(from: string)
    }
}
