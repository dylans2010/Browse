import SwiftUI

struct DiagnosticsView: View {
    @State var viewModel: DiagnosticsViewModel

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
        .task { /* In a real app we would pass the active webView here */ }
        .frame(minWidth: 300)
    }
}
