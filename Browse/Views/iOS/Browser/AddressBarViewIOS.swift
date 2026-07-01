import SwiftUI

struct AddressBarViewIOS: View {
    @Binding var text: String
    var isLoading: Bool
    var progress: Double
    var isReaderAvailable: Bool
    @Binding var isReaderModeActive: Bool
    var onCommit: () -> Void
    var onReload: () -> Void

    private var backgroundColor: Color {
        return Color(uiColor: .secondarySystemBackground)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            if isLoading {
                GeometryReader { geo in
                    Rectangle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: geo.size.width * CGFloat(progress))
                }
            }

            HStack {
                if isReaderAvailable {
                    Button(action: { isReaderModeActive.toggle() }) {
                        Image(systemName: "text.justify.left")
                            .foregroundColor(isReaderModeActive ? .blue : .secondary)
                    }
                    .buttonStyle(.plain)
                    .help("Reader Mode")
                } else {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }

                TextField("Search or enter address", text: $text)
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .autocorrectionDisabled()
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

                // Fixed: previously called onCommit() (navigate); now correctly reloads the page.
                Button(action: { onReload() }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .background(backgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}
