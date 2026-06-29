import SwiftUI
import SwiftData

struct ExtensionManagerView: View {
    @Query private var extensions: [BrowserExtension]
    @Environment(\.modelContext) private var context

    var body: some View {
        List {
            ForEach(extensions) { ext in
                HStack {
                    VStack(alignment: .leading) {
                        Text(ext.name).font(.headline)
                        Text(ext.descriptionText).font(.subheadline).foregroundColor(.secondary)
                    }
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { ext.isActive },
                        set: { ext.isActive = $0; try? context.save() }
                    ))
                    .labelsHidden()
                }
            }
            .onDelete(perform: deleteExtensions)
        }
        .navigationTitle("Extensions")
    }

    private func deleteExtensions(at offsets: IndexSet) {
        for index in offsets {
            context.delete(extensions[index])
        }
        try? context.save()
    }
}
