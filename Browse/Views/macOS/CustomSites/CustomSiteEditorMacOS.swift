import SwiftUI

struct CustomSiteEditorMacOS: View {
    @State var viewModel: CustomSiteViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Custom Sites Editor")
                    .font(.headline)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding()

            Divider()

            ScrollView {
                Form {
                    Section("Visual Editor") {
                        TextField("Typography", text: Binding(
                            get: { viewModel.currentConfig?.typography ?? "" },
                            set: { viewModel.updateVisualProperty(typography: $0) }
                        ))
                        TextField("Accent Color", text: Binding(
                            get: { viewModel.currentConfig?.accentColor ?? "" },
                            set: { viewModel.updateVisualProperty(accentColor: $0) }
                        ))
                    }

                    Section("CSS Editor") {
                        TextEditor(text: Binding(
                            get: { viewModel.currentConfig?.customCSS ?? "" },
                            set: { viewModel.updateCSS($0) }
                        ))
                        .frame(minHeight: 150)
                        .font(.system(.body, design: .monospaced))
                    }

                    Section("JavaScript Editor") {
                        TextEditor(text: Binding(
                            get: { viewModel.currentConfig?.customJS ?? "" },
                            set: { viewModel.updateJS($0) }
                        ))
                        .frame(minHeight: 150)
                        .font(.system(.body, design: .monospaced))
                    }

                    Section("Page Actions") {
                        Button("Inspect & Hide Elements") {
                            viewModel.toggleElementInspector()
                        }

                        if !viewModel.hiddenElements.isEmpty {
                            Button("Restore Hidden Elements") {
                                viewModel.restoreHiddenElements()
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .frame(width: 300)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
    }
}
