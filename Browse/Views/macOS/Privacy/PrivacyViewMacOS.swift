import SwiftUI

struct PrivacyViewMacOS: View {
    @State var viewModel = PermissionViewModel()
    var currentHost: String?

    var body: some View {
        List {
            Section("Site Permissions") {
                if viewModel.permissions.isEmpty {
                    Text("No specific permissions set").foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.permissions) { permission in
                        LabeledContent(permission.permissionType, value: permission.state)
                    }
                }
            }
        }
        .navigationTitle("Privacy")
        .onAppear { viewModel.loadPermissions(for: currentHost) }
    }
}
