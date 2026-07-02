#if os(macOS)
import SwiftUI

struct TabBarMacOS: View {
    @Bindable var tabManager: TabManager

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(tabManager.tabs) { tab in
                    TabCardMacOS(
                        tab: tab,
                        isSelected: tabManager.activeTabId == tab.id,
                        onClose: { tabManager.closeTab(id: tab.id) },
                        onSelect: { tabManager.selectTab(id: tab.id) }
                    )
                    .frame(minWidth: 140, maxWidth: 220)

                    Divider().frame(height: 20)
                }

                Button(action: { tabManager.createTab(url: nil, profileId: tabManager.tabs.first?.item.profileId ?? UUID()) }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
                .padding(.leading, 8)
            }
            .padding(.horizontal, 4)
        }
        .frame(height: 38)
        .background(.bar)
    }
}
#endif
