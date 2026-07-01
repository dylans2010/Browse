import SwiftUI

struct ExtensionManagerIOS: View {
    @State var viewModel: ExtensionViewModel
    @State private var description: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Describe extension...", text: $description)
                    .textFieldStyle(.roundedBorder)
                Button("Generate") {
                    Task { await viewModel.generate(description: description) }
                }
                .disabled(description.isEmpty || viewModel.isGenerating)
            }
            .padding()

            if viewModel.isGenerating {
                ProgressView("Generating extension...")
            }

            List {
                ForEach(viewModel.extensions) { ext in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(ext.name).font(.headline)
                            Text(ext.version).font(.caption)
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { ext.isEnabled },
                            set: { ext.isEnabled = $0 }
                        ))
                    }
                }
            }
        }
        .onAppear { viewModel.loadExtensions() }
    }
}
