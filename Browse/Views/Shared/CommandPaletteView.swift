import SwiftUI

struct CommandPaletteView: View {
    @Bindable var viewModel: CommandPaletteViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            TextField("Search commands...", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .padding()

            List(viewModel.filteredActions) { action in
                Button(action: {
                    action.action()
                    dismiss()
                }) {
                    Label(action.title, systemImage: action.icon)
                }
            }
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}
