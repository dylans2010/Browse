import SwiftUI
import SwiftData

struct DownloadManagerView: View {
    @Query(sort: \DownloadItem.createdAt, order: .reverse) var downloads: [DownloadItem]

    var body: some View {
        List {
            ForEach(downloads) { item in
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "doc.fill")
                        Text(item.filename)
                            .font(.headline)
                        Spacer()
                        Text(item.status.capitalized)
                            .font(.caption)
                            .foregroundColor(statusColor(item.status))
                    }

                    if item.status == "downloading" {
                        ProgressView(value: Double(item.receivedBytes), total: Double(item.totalBytes))
                    }

                    Text(item.url.absoluteString)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .navigationTitle("Downloads")
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "completed": return .green
        case "failed": return .red
        case "downloading": return .blue
        default: return .secondary
        }
    }
}
