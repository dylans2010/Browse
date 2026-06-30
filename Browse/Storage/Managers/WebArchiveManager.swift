import Foundation
import WebKit

final class WebArchiveManager {
    static let shared = WebArchiveManager()

    /// Saves a web page as a web archive.
    func saveWebArchive(from webView: WKWebView, filename: String) async -> URL? {
        do {
            let data = try await webView.createWebArchiveData()
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let archiveURL = documentsURL.appendingPathComponent("\(filename).webarchive")
            try data.write(to: archiveURL)
            return archiveURL
        } catch {
            LoggingService.shared.error("Failed to save web archive", error: error)
            return nil
        }
    }
}
