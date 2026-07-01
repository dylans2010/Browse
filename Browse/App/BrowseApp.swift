import SwiftUI

@main
struct BrowseApp: App {
    let persistence = PersistenceProvider.shared
    @State private var aiSettings = AISettings()

    init() {
        // Ensure at least one profile exists
        let context = PersistenceProvider.shared.mainContext
        let fetchDescriptor = FetchDescriptor<Profile>()
        if let existing = try? context.fetch(fetchDescriptor), existing.isEmpty {
            let defaultProfile = Profile(name: "Default", icon: "person.fill")
            context.insert(defaultProfile)
            try? context.save()
        }
    }

    var body: some Scene {
        #if os(macOS)
        WindowGroup {
            MainWindowView()
                .modelContainer(persistence.container)
        }
        .commands {
            SidebarCommands()
        }
        #else
        WindowGroup {
            MainTabView()
                .modelContainer(persistence.container)
        }
        #endif

        #if os(macOS)
        Settings {
            SettingsViewMacOS(aiSettings: aiSettings)
                .modelContainer(persistence.container)
        }
        #endif
    }
}
