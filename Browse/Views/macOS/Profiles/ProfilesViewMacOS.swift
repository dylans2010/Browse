import SwiftUI
import SwiftData

struct ProfilesView: View {
    @Query var profiles: [Profile]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            ForEach(profiles) { profile in
                HStack {
                    Image(systemName: profile.icon)
                    Text(profile.name)
                    if profile.isPrivate {
                        Spacer()
                        Image(systemName: "hand.raised.fill").foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Profiles")
        .toolbar {
            Button(action: addProfile) {
                Image(systemName: "plus")
            }
        }
        .frame(minWidth: 300)
    }

    private func addProfile() {
        let newProfile = Profile(name: "New Profile")
        modelContext.insert(newProfile)
    }
}
