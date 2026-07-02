#if os(macOS)
import SwiftUI
import AppKit
import SwiftData

struct SidebarViewMacOS: View {
    @Bindable var tabManager: TabManager
    @Query var profiles: [Profile]
    @State private var selectedProfileId: UUID?
    @State private var uiConfig: UIConfiguration?
    @State private var isShowingCustomizer = false

    var body: some View {
        List {
            if uiConfig?.useVerticalTabs ?? true {
                Section("Tabs") {
                    ForEach(tabManager.tabs) { tab in
                        NavigationLink(value: tab.id) {
                            HStack(spacing: uiConfig?.sidebarSpacing ?? 8) {
                                if tab.item.isLoading {
                                    ProgressView().controlSize(.small).scaleEffect(0.6)
                                } else if let data = tab.item.faviconData, let image = NSImage(data: data) {
                                    Image(nsImage: image).resizable().frame(width: 16, height: 16)
                                } else {
                                    Image(systemName: "globe")
                                        .font(.system(size: uiConfig?.sidebarIconSize ?? 16))
                                }

                                Text(tab.item.title.isEmpty ? "New Tab" : tab.item.title)
                                    .lineLimit(1)

                                Spacer()

                                if tab.item.isPlayingAudio {
                                    Image(systemName: "speaker.wave.2.fill").font(.caption2)
                                }
                            }
                        }
                        .contextMenu {
                            Button("Close Tab") { tabManager.closeTab(id: tab.id) }
                            Button("Duplicate Tab") { tabManager.createTab(url: tab.webPage.url, profileId: tab.item.profileId) }
                            Button(tabManager.pinnedTabIds.contains(tab.id) ? "Unpin Tab" : "Pin Tab") {
                                if tabManager.pinnedTabIds.contains(tab.id) {
                                    tabManager.unpinTab(id: tab.id)
                                } else {
                                    tabManager.pinTab(id: tab.id)
                                }
                            }
                        }
                    }
                }
            }

            Section("Library") {
                NavigationLink(destination: BookmarkManagerView()) {
                    Label("Bookmarks", systemImage: "bookmark")
                }
                NavigationLink(destination: HistoryManagerView()) {
                    Label("History", systemImage: "clock")
                }
                NavigationLink(destination: ReadingListView()) {
                    Label("Reading List", systemImage: "book")
                }
                NavigationLink(destination: FavoritesGridMacOS(onSelect: { url in
                    tabManager.createTab(url: url, profileId: selectedProfileId ?? UUID())
                })) {
                    Label("Favorites", systemImage: "star")
                }
            }

            Section("Profiles") {
                Picker("Profile", selection: $selectedProfileId) {
                    ForEach(profiles) { profile in
                        Text(profile.name).tag(profile.id as UUID?)
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .background(.regularMaterial)
        .onAppear {
            if let first = profiles.first {
                selectedProfileId = first.id
                uiConfig = ThemeManager.shared.getConfiguration(for: first.id)
            }
        }
    }
}
#endif
