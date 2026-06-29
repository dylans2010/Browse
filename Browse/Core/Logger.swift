import Foundation
import os

/// Centralized logger for the application.
final class Logger {
    static let shared = Logger()

    private let browserLog = os.Logger(subsystem: "com.browse.app", category: "Browser")
    private let aiLog = os.Logger(subsystem: "com.browse.app", category: "AI")
    private let networkLog = os.Logger(subsystem: "com.browse.app", category: "Networking")

    func info(_ message: String, category: LogCategory = .browser) {
        log(message, level: .info, category: category)
    }

    func error(_ message: String, category: LogCategory = .browser) {
        log(message, level: .error, category: category)
    }

    private func log(_ message: String, level: OSLogType, category: LogCategory) {
        let logger = switch category {
        case .browser: browserLog
        case .ai: aiLog
        case .networking: networkLog
        }
        logger.log(level: level, "\(message)")
    }

    enum LogCategory {
        case browser, ai, networking
    }
}
