import Foundation
import OSLog

final class LoggingService {
    static let shared = LoggingService()
    private let logger = Logger(subsystem: "com.browse.app", category: "General")

    private init() {}

    func info(_ message: String) {
        logger.info("\(message)")
    }

    func error(_ message: String, error: Error? = nil) {
        if let error = error {
            logger.error("\(message): \(error.localizedDescription)")
        } else {
            logger.error("\(message)")
        }
    }

    func debug(_ message: String) {
        logger.debug("\(message)")
    }
}
