import Foundation
import Observation
import WebKit

@Observable
final class DiagnosticsViewModel {
    private let performanceManager = PerformanceManager.shared

    var metrics: PerformanceManager.PerformanceMetrics?

    func refreshMetrics(webView: WKWebView) async {
        metrics = await performanceManager.getMetrics(for: webView)
    }
}
