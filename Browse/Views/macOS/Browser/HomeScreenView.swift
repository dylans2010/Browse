import SwiftUI

struct HomeScreenView: View {
    @Bindable var tabManager: TabManager
    let profileId: UUID

    @State private var searchText: String = ""
    @State private var isShowingCustomize = false
    @State private var config: HomeConfiguration?

    var body: some View {
        ZStack {
            backgroundView

            VStack(spacing: 40) {
                Spacer()

                if config?.showQuickSearch ?? true {
                    // Search Bar
                    VStack(spacing: 20) {
                        Text("Browse")
                            .font(.system(size: 48, weight: .bold))

                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search or enter address", text: $searchText)
                                .textFieldStyle(.plain)
                                .onSubmit {
                                    navigateToURL()
                                }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(NSColor.controlBackgroundColor)))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.2)))
                        .frame(maxWidth: 600)
                    }
                }

                if config?.showPinnedSites ?? true {
                    PinnedSitesGridView(profileId: profileId) { url in
                        tabManager.activeTab?.webPage.load(url: url)
                    }
                }

                if config?.showRecentPages ?? true {
                    RecentPagesView(profileId: profileId) { url in
                        tabManager.activeTab?.webPage.load(url: url)
                    }
                }

                Spacer()

                HStack {
                    Spacer()
                    Button(action: { isShowingCustomize.toggle() }) {
                        Label("Customize", systemImage: "paintbrush")
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $isShowingCustomize) {
            if let config = config {
                HomeScreenCustomizeView(config: config)
            }
        }
        .onAppear {
            config = StartupManager.shared.getHomeConfiguration(for: profileId)
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        if let config = config {
            switch config.backgroundType {
            case "image":
                if let path = config.backgroundImagePath, let image = NSImage(contentsOfFile: path) {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: config.blurIntensity)
                } else {
                    Color(NSColor.windowBackgroundColor)
                }
            case "acrylic":
                VisualEffectView(material: .underWindowBackground, blendingMode: .behindWindow)
            case "glass":
                VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
            default:
                Color(NSColor.windowBackgroundColor)
            }
        } else {
            Color(NSColor.windowBackgroundColor)
        }
    }

struct PinnedSitesGridView: View {
    let profileId: UUID
    @Query private var bookmarks: [Bookmark]
    var onSelect: (URL) -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
            ForEach(bookmarks.prefix(8)) { bookmark in
                Button(action: {
                    if let url = bookmark.url {
                        onSelect(url)
                    }
                }) {
                    VStack {
                        Image(systemName: "globe")
                            .font(.system(size: 32))
                        Text(bookmark.title)
                            .font(.caption)
                            .lineLimit(1)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: 800)
    }
}

struct RecentPagesView: View {
    let profileId: UUID
    @Query(sort: \HistoryItem.timestamp, order: .reverse) private var history: [HistoryItem]
    var onSelect: (URL) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Recently Visited")
                .font(.headline)

            ForEach(history.prefix(5)) { item in
                HStack {
                    Image(systemName: "clock")
                    Text(item.title)
                    Spacer()
                    Text(item.timestamp, style: .time)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle())
                .onTapGesture {
                    onSelect(item.url)
                }
            }
        }
        .frame(maxWidth: 800, alignment: .leading)
    }
}

    private func navigateToURL() {
        let result = CommandManager.shared.parse(searchText)

        switch result {
        case .url(let url):
            if let activeTab = tabManager.activeTab {
                activeTab.webPage.load(url: url)
            } else {
                tabManager.createTab(url: url, profileId: profileId)
            }
        case .search(let query):
            let url = SearchProviderManager.shared.searchURL(for: query)
            if let activeTab = tabManager.activeTab {
                activeTab.webPage.load(url: url)
            } else {
                tabManager.createTab(url: url, profileId: profileId)
            }
        case .askGPT(let query):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let url = URL(string: "https://chatgpt.com/?q=\(encodedQuery)")!
            tabManager.createTab(url: url, profileId: profileId)
        case .browserCommand(let action):
            action()
            searchText = ""
        case .none:
            break
        }
    }
}
