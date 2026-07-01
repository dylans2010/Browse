import SwiftUI

struct WorkspaceListView: View {
    @State var viewModel: WorkspaceViewModel
    let profileId: UUID

    var body: some View {
        List {
            ForEach(viewModel.workspaces) { workspace in
                HStack {
                    Image(systemName: workspace.icon)
                        .foregroundColor(Color(workspace.color))
                    Text(workspace.name)
                    Spacer()
                    if viewModel.activeWorkspaceId == workspace.id {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.activeWorkspaceId = workspace.id
                }
            }
        }
    }
}
