import Foundation
import Observation
import SwiftData

/// Manages file downloads with persistence.
@Observable
final class DownloadManager: NSObject, URLSessionDownloadDelegate {
    static let shared = DownloadManager()
    private let context = PersistenceProvider.shared.mainContext

    private var session: URLSession!
    var activeDownloads: [URL: DownloadItem] = [:]

    override private init() {
        super.init()
        let config = URLSessionConfiguration.background(withIdentifier: "com.browse.downloads")
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }

    func startDownload(url: URL, profileId: UUID) {
        let task = session.downloadTask(with: url)
        let item = DownloadItem(url: url, filename: url.lastPathComponent, profileId: profileId)
        activeDownloads[url] = item
        context.insert(item)
        try? context.save()
        task.resume()
    }

    // MARK: - URLSessionDownloadDelegate

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url,
              let item = activeDownloads[url] else { return }

        let fileManager = FileManager.default
        let downloadsURL = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        let destinationURL = downloadsURL.appendingPathComponent(item.filename)

        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.moveItem(at: location, to: destinationURL)

            item.status = "completed"
            item.finishedAt = Date()
            item.localPath = destinationURL.path

            activeDownloads.removeValue(forKey: url)
            try? context.save()
        } catch {
            item.status = "failed"
            try? context.save()
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url,
              let item = activeDownloads[url] else { return }

        item.receivedBytes = totalBytesWritten
        item.totalBytes = totalBytesExpectedToWrite
    }
}
