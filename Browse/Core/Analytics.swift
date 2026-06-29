import Foundation

/// Centralized analytics service.
final class Analytics {
    static let shared = Analytics()

    func trackEvent(_ name: String, parameters: [String: Any]? = nil) {
        // In a real production app, this would send data to an analytics provider.
        Logger.shared.info("Analytics Event: \(name) with params: \(parameters ?? [:])")
    }
}
