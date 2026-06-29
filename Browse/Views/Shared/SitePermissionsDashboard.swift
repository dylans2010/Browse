import SwiftUI
import SwiftData

struct SitePermissionsDashboard: View {
    @Query private var permissions: [SitePermission]
    @Environment(\.modelContext) private var context

    var body: some View {
        List {
            ForEach(permissions) { permission in
                HStack {
                    VStack(alignment: .leading) {
                        Text(permission.origin).font(.headline)
                        Text(permission.permissionType).font(.subheadline).foregroundColor(.secondary)
                    }
                    Spacer()
                    Picker("State", selection: Binding(
                        get: { permission.state },
                        set: { permission.state = $0; try? context.save() }
                    )) {
                        Text("Granted").tag("granted")
                        Text("Denied").tag("denied")
                        Text("Prompt").tag("prompt")
                    }
                    .pickerStyle(.menu)
                }
            }
            .onDelete(perform: deletePermissions)
        }
        .navigationTitle("Site Permissions")
    }

    private func deletePermissions(at offsets: IndexSet) {
        for index in offsets {
            context.delete(permissions[index])
        }
        try? context.save()
    }
}
