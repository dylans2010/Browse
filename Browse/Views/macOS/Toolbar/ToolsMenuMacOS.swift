#if os(macOS)
import SwiftUI

struct ToolsMenuMacOS: View {
    @State private var viewModel = ToolsMenuMacOSViewModel()
    let activeTab: TabManager.TabWrapper?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Page Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Page").font(.caption).fontWeight(.bold).foregroundColor(.secondary)
                    Button(action: {
                        if let tab = activeTab {
                            viewModel.toggleFavorite(for: tab)
                        }
                    }) {
                        Label(viewModel.isCurrentSiteFavorited ? "Remove from Favorites" : "Add to Favorites",
                              systemImage: viewModel.isCurrentSiteFavorited ? "star.fill" : "star")
                    }
                    Button(action: { viewModel.invoke(command: "reader mode") }) {
                        Label("Reader Mode", systemImage: "text.justify.left")
                    }
                }

                Divider()

                // Site Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Site").font(.caption).fontWeight(.bold).foregroundColor(.secondary)
                    Button(action: { viewModel.invoke(command: "open site settings") }) {
                        Label("Site Settings", systemImage: "gearshape")
                    }
                }

                Divider()

                // Browser Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Browser").font(.caption).fontWeight(.bold).foregroundColor(.secondary)
                    Button(action: { viewModel.invoke(command: "new tab") }) {
                        Label("New Tab", systemImage: "plus")
                    }
                    Button(action: { viewModel.invoke(command: "open downloads") }) {
                        Label("Downloads", systemImage: "arrow.down.circle")
                    }
                }

                Divider()

                // AI Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("AI").font(.caption).fontWeight(.bold).foregroundColor(.secondary)
                    Button(action: { viewModel.invoke(command: "summarize") }) {
                        Label("Summarize Page", systemImage: "sparkles")
                    }
                }
            }
            .padding()
        }
        .frame(width: 220, height: 350)
        .onAppear {
            if let tab = activeTab {
                viewModel.checkFavoriteStatus(for: tab.webPage.url, profileId: tab.item.profileId)
            }
        }
    }
}
#endif
