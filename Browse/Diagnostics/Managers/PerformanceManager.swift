import Foundation
import Observation
import WebKit

@Observable
final class PerformanceManager {
    static let shared = PerformanceManager()

    struct PerformanceMetrics {
        let loadTime: TimeInterval
        let memoryUsage: Int64
    }

    /// Fetches performance metrics using JavaScript evaluation for better accuracy.
    func getMetrics(for webView: WKWebView) async -> PerformanceMetrics {
        let script = """
        (function() {
            var t = window.performance.timing;
            return {
                loadTime: (t.loadEventEnd - t.navigationStart) / 1000,
                memory: window.performance.memory ? window.performance.memory.usedJSHeapSize : 0
            };
        })()
        """

        do {
            if let result = try await webView.evaluateJavaScript(script) as? [String: Any],
               let loadTime = result["loadTime"] as? Double,
               let memory = result["memory"] as? Int64 {
                return PerformanceMetrics(loadTime: loadTime, memoryUsage: memory)
            }
        } catch {
            LoggingService.shared.error("Failed to fetch performance metrics", error: error)
        }

        return PerformanceMetrics(loadTime: 0, memoryUsage: 0)
    }
}
