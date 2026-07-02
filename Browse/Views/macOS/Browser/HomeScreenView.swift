#if os(macOS)
import SwiftUI

struct HomeScreenView: View {
    @Bindable var tabManager: TabManager
    let profileId: UUID

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Spacer().frame(height: 40)

                Text("Good Morning")
                    .font(.system(size: 32, weight: .bold))

                VStack(alignment: .leading, spacing: 20) {
                    Text("Favorites")
                        .font(.headline)
                        .padding(.horizontal)

                    FavoritesGridMacOS(onSelect: { url in
                        if let activeTab = tabManager.activeTab {
                            activeTab.webPage.load(url: url)
                        } else {
                            tabManager.createTab(url: url, profileId: profileId)
                        }
                    })
                }
                .frame(maxWidth: 800)

                FrequentlyVisitedMacOS(onSelect: { url in
                    if let activeTab = tabManager.activeTab {
                        activeTab.webPage.load(url: url)
                    } else {
                        tabManager.createTab(url: url, profileId: profileId)
                    }
                })
                .frame(maxWidth: 800)

                Spacer()
            }
            .padding()
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}
#endif
