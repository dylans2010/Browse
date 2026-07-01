import SwiftUI

struct ThemesView: View {
    @State var viewModel: ThemeViewModel
    var profileId: UUID

    var body: some View {
        Form {
            Section("Toolbar Customization") {
                if let config = viewModel.currentConfig {
                    ForEach(config.toolbarItems, id: \.self) { item in
                        Text(item)
                    }
                } else {
                    Text("Loading configuration...")
                }
            }
        }
        .navigationTitle("Themes & UI")
        .onAppear { viewModel.loadConfig(for: profileId) }
    }
}
