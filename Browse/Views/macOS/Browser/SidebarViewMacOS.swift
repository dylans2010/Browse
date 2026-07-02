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
        ZStack {
            sidebarBackground

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
                            HStack(spacing: uiConfig?.sidebarSpacing ?? 8) {
                                Image(systemName: tabManager.pinnedTabIds.contains(tab.id) ? "pin.fill" : "globe")
                                    .font(.system(size: uiConfig?.sidebarIconSize ?? 18))
                                    .foregroundColor(tabManager.pinnedTabIds.contains(tab.id) ? .accentColor : .primary)
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
                            if tabManager.pinnedTabIds.contains(tab.id) {
                                Button("Unpin Tab") {
                                    tabManager.unpinTab(id: tab.id)
                                }
                            } else {
                                Button("Pin Tab") {
                                    tabManager.pinTab(id: tab.id)
                                }
                            }
                            Button("Close All Tabs") {
                                tabManager.closeAllTabs()
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

                Section("Appearance") {
                    Button(action: { isShowingCustomizer.toggle() }) {
                        Label("Customize Sidebar", systemImage: "paintbrush")
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: uiConfig?.sidebarWidth ?? 250)
        .toolbar {
            ToolbarItem {
                Button(action: {
                    tabManager.createTab(url: nil, profileId: selectedProfileId ?? UUID())
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            if let first = profiles.first {
                selectedProfileId = first.id
                uiConfig = ThemeManager.shared.getConfiguration(for: first.id)
            }
        }
        .onChange(of: selectedProfileId) { _, newValue in
            if let id = newValue {
                uiConfig = ThemeManager.shared.getConfiguration(for: id)
            }
        }
        .sheet(isPresented: $isShowingCustomizer) {
            if let config = uiConfig {
                SidebarCustomizerView(config: config)
            }
        }
    }

    @ViewBuilder
    private var sidebarBackground: some View {
        if let config = uiConfig {
            switch config.sidebarMaterial {
            case "glass":
                VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
            case "acrylic":
                VisualEffectView(material: .underWindowBackground, blendingMode: .behindWindow)
            default:
                Color.clear
            }
        }
    }
}

struct SidebarCustomizerView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var config: UIConfiguration

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Customize Sidebar")
                    .font(.headline)
                Spacer()
                Button("Done") {
                    ThemeManager.shared.saveConfiguration()
                    dismiss()
                }
            }
            .padding()

            Divider()

            Form {
                Section("Dimensions") {
                    Slider(value: $config.sidebarWidth, in: 150...400) {
                        Text("Width")
                    }
                    Slider(value: $config.sidebarIconSize, in: 12...32) {
                        Text("Icon Size")
                    }
                    Slider(value: $config.sidebarSpacing, in: 0...20) {
                        Text("Spacing")
                    }
                }

                Section("Appearance") {
                    Picker("Material", selection: $config.sidebarMaterial) {
                        Text("Glass").tag("glass")
                        Text("Acrylic").tag("acrylic")
                        Text("Solid").tag("solid")
                    }

                    Picker("Accent Color", selection: $config.accentColor) {
                        Text("Blue").tag("blue")
                        Text("Red").tag("red")
                        Text("Green").tag("green")
                        Text("Orange").tag("orange")
                        Text("Purple").tag("purple")
                    }

                    Toggle("Vertical Tabs", isOn: $config.useVerticalTabs)
                }
            }
            .padding()
        }
        .frame(width: 350, height: 450)
    }
}
#endif
