#if os(macOS)
import AppKit
import SwiftUI
import UniformTypeIdentifiers


struct HomeScreenCustomizeView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var config: HomeConfiguration

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Customize Home")
                    .font(.headline)
                Spacer()
                Button("Done") {
                    StartupManager.shared.saveHomeConfiguration()
                    dismiss()
                }
            }
            .padding()

            Divider()

            Form {
                Section("Background") {
                    Picker("Style", selection: $config.backgroundType) {
                        Text("Solid").tag("solid")
                        Text("Glass").tag("glass")
                        Text("Acrylic").tag("acrylic")
                        Text("Image").tag("image")
                    }

                    if config.backgroundType == "image" {
                        Button("Select Image...") {
                            selectImage()
                        }

                        Slider(value: $config.blurIntensity, in: 0...50) {
                            Text("Blur")
                        }
                    }
                }

                Section("Visible Sections") {
                    Toggle("Pinned Sites", isOn: $config.showPinnedSites)
                    Toggle("Recently Visited", isOn: $config.showRecentPages)
                    Toggle("AI Shortcuts", isOn: $config.showAIShortcuts)
                    Toggle("Quick Search", isOn: $config.showQuickSearch)
                }
            }
            .padding()
        }
        .frame(width: 400, height: 500)
    }

    private func selectImage() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.image]

        if panel.runModal() == .OK {
            config.backgroundImagePath = panel.url?.path
        }
    }
}
#endif
