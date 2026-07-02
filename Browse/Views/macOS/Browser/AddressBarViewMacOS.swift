#if os(macOS)
import SwiftUI
import AppKit

struct AddressBarViewMacOS: View {
    @Binding var text: String
    var isLoading: Bool
    var progress: Double
    var isReaderAvailable: Bool
    @Binding var isReaderModeActive: Bool
    var onCommit: () -> Void
    var onReload: () -> Void

    @State private var debounceTask: Task<Void, Never>?

    var body: some View {
        ZStack(alignment: .leading) {
            if isLoading {
                GeometryReader { geo in
                    Rectangle()
                        .fill(Color.accentColor.opacity(0.2))
                        .frame(width: geo.size.width * CGFloat(progress))
                }
            }

            HStack {
                if isReaderAvailable {
                    Button(action: { isReaderModeActive.toggle() }) {
                        Image(systemName: "text.justify.left")
                            .foregroundColor(isReaderModeActive ? .accentColor : .secondary)
                    }
                    .buttonStyle(.plain)
                } else {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }

                TextField("Search or enter address", text: $text)
                    .textFieldStyle(.plain)
                    .onChange(of: text) { _, newValue in
                        // Debounce logic for suggestions or other expensive operations
                        debounceTask?.cancel()
                        debounceTask = Task {
                            try? await Task.sleep(nanoseconds: 250_000_000) // 250ms
                            if !Task.isCancelled {
                                // Perform suggestions fetch
                            }
                        }
                    }
                    .onSubmit {
                        onCommit()
                    }

                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }

                Button(action: { onReload() }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 0.5)
        )
    }
}
#endif
