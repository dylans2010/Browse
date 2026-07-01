import SwiftUI

struct SessionsViewIOS: View {
    @State var viewModel: SessionViewModel
    var profileId: UUID

    var body: some View {
        List {
            ForEach(viewModel.snapshots) { snapshot in
                VStack(alignment: .leading) {
                    Text(snapshot.name).font(.headline)
                    Text("\(snapshot.tabItems.count) tabs")
                        .font(.caption).foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Session Snapshots")
        .onAppear { SessionSnapshotManager.shared.fetchSnapshots(for: profileId) }
    }
}
