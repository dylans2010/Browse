import SwiftUI

struct CustomSiteEditorView: View {
    @State var viewModel: CustomSiteViewModel

    var body: some View {
        Form {
            Section("Visual Editor") {
                TextField("Typography", text: Binding(
                    get: { viewModel.currentConfig?.typography ?? "" },
                    set: { viewModel.currentConfig?.typography = \$0 }
                ))
                TextField("Accent Color", text: Binding(
                    get: { viewModel.currentConfig?.accentColor ?? "" },
                    set: { viewModel.currentConfig?.accentColor = \$0 }
                ))
            }

            Section("CSS Editor") {
                TextEditor(text: Binding(
                    get: { viewModel.currentConfig?.customCSS ?? "" },
                    set: { viewModel.updateCSS(\$0) }
                ))
                .frame(minHeight: 200)
            }

            Section("JavaScript Editor") {
                TextEditor(text: Binding(
                    get: { viewModel.currentConfig?.customJS ?? "" },
                    set: { viewModel.updateJS(\$0) }
                ))
                .frame(minHeight: 200)
            }
        }
    }
}
