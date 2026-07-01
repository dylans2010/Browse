import Foundation

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        LoggingService.shared.debug("Analytics Event: \(name) - Parameters: \(parameters ?? [:])")
    }

    func logScreenView(_ screenName: String) {
        logEvent("screen_view", parameters: ["screen_name": screenName])
    }
}
