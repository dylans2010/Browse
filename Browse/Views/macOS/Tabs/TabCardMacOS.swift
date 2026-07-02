#if os(macOS)
import SwiftUI

struct TabCardMacOS: View {
    let tab: TabManager.TabWrapper
    let isSelected: Bool
    let onClose: () -> Void
    let onSelect: () -> Void

    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 8) {
            if tab.item.isLoading {
                ProgressView()
                    .controlSize(.small)
                    .scaleEffect(0.6)
            } else if let faviconData = tab.item.faviconData, let image = NSImage(data: faviconData) {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: 16, height: 16)
            } else {
                Image(systemName: "globe")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Text(tab.item.title.isEmpty ? "New Tab" : tab.item.title)
                .font(.system(size: 12))
                .lineLimit(1)
                .foregroundColor(isSelected ? .primary : .secondary)

            Spacer()

            if tab.item.isPlayingAudio {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }

            if isHovering || isSelected {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                }
                .buttonStyle(.plain)
                .frame(width: 16, height: 16)
                .background(Color.secondary.opacity(0.1))
                .clipShape(Circle())
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 34)
        .background(isSelected ? Color(NSColor.selectedContentBackgroundColor).opacity(0.1) : Color.clear)
        .onHover { hovering in
            isHovering = hovering
        }
        .onTapGesture {
            onSelect()
        }
    }
}
#endif
