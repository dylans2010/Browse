import SwiftUI
import WebKit

struct DiagnosticsViewMacOS: View {
    @State var viewModel: DiagnosticsViewModel
    let webView: WKWebView?

    var body: some View {
        List {
            Section("Performance Metrics") {
                if let metrics = viewModel.metrics {
                    LabeledContent("Load Time", value: String(format: "%.2f s", metrics.loadTime))
                    LabeledContent("Memory Usage", value: ByteCountFormatter.string(fromByteCount: metrics.memoryUsage, countStyle: .memory))
                } else {
                    Text("No metrics available. Load a page to see performance data.")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Diagnostics")
        .task {
            if let webView = webView {
                await viewModel.refreshMetrics(webView: webView)
            }
        }
        .frame(minWidth: 300)
    }
}
