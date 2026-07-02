#if os(macOS)
import SwiftUI

struct FrequentlyVisitedMacOS: View {
    @State private var items: [HistoryItem] = []
    var onSelect: (URL) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Frequently Visited")
                .font(.headline)
                .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                ForEach(items) { item in
                    Button(action: { onSelect(item.url) }) {
                        VStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.secondary.opacity(0.1))
                                .frame(width: 50, height: 50)
                                .overlay(Image(systemName: "globe"))

                            Text(item.title)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .onAppear {
            items = HistoryManager.shared.mostVisited(limit: 10)
        }
    }
}
#endif
