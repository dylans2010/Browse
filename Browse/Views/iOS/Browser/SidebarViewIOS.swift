import SwiftUI
import SwiftData

struct SidebarViewIOS: View {
    @Bindable var tabManager: TabManager
    @Query var profiles: [Profile]
    @State private var selectedProfileId: UUID?

    var body: some View {
        List {
            Section("Profiles") {
                Picker("Active Profile", selection: $selectedProfileId) {
                    ForEach(profiles) { profile in
                        Label(profile.name, systemImage: profile.icon).tag(profile.id as UUID?)
                    }
                }
                .labelsHidden()
            }

            Section("Tabs") {
                ForEach(tabManager.tabs) { tab in
                    NavigationLink(value: tab.id) {
                        HStack {
                            Image(systemName: "globe")
                            Text(tab.webPage.title.isEmpty ? "New Tab" : tab.webPage.title)
                                .lineLimit(1)
                        }
                    }
                    .contextMenu {
                        Button("Close Tab") {
                            tabManager.closeTab(id: tab.id)
                        }
                        Button("Duplicate Tab") {
                            tabManager.createTab(url: tab.webPage.url, profileId: tab.item.profileId)
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
                NavigationLink(destination: DownloadManagerView()) {
                    Label("Downloads", systemImage: "arrow.down.circle")
                }
                NavigationLink(destination: ReadingListView()) {
                    Label("Reading List", systemImage: "book")
                }
            }
        }
        .listStyle(.sidebar)
        .toolbar {
            ToolbarItem {
                Button(action: {
                    tabManager.createTab(url: URL(string: "https://www.google.com"), profileId: selectedProfileId ?? UUID())
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            if let first = profiles.first {
                selectedProfileId = first.id
            }
        }
    }
}
