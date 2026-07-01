import Foundation

final class AIRateLimiter {
    private var lastRequestDate: Date?
    private let minInterval: TimeInterval = 1.0 // 1 request per second

    func waitForAvailability() async throws {
        if let last = lastRequestDate {
            let elapsed = Date().timeIntervalSince(last)
            if elapsed < minInterval {
                try await Task.sleep(nanoseconds: UInt64((minInterval - elapsed) * 1_000_000_000))
            }
        }
        lastRequestDate = Date()
    }
}
