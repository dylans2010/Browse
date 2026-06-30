import SwiftUI
import SwiftData

struct HistoryManagerView: View {
    @Query(sort: \HistoryItem.timestamp, order: .reverse) var history: [HistoryItem]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            ForEach(history) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        Text(item.url.absoluteString)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(item.timestamp, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .contextMenu {
                    Button("Delete") {
                        modelContext.delete(item)
                    }
                }
            }
        }
        .navigationTitle("History")
        .toolbar {
            Button("Clear All") {
                try? modelContext.delete(model: HistoryItem.self)
            }
        }
    }
}
