import SwiftUI

struct ThemesViewIOS: View {
    @State var viewModel = ThemeViewModel()
    var profileId: UUID?

    var body: some View {
        Form {
            Section("Toolbar Customization") {
                if let config = viewModel.currentConfig {
                    ForEach(config.toolbarItems, id: \.self) { item in
                        Text(item)
                    }
                } else {
                    Text("Select a profile to view configuration.")
                }
            }
        }
        .navigationTitle("Themes & UI")
        .onAppear {
            if let profileId = profileId {
                viewModel.loadConfig(for: profileId)
            }
        }
    }
}
