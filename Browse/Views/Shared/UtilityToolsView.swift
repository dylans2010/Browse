import SwiftUI

struct UtilityToolsView: View {
    @Bindable var utilities = BrowserUtilities.shared
    var activeTab: TabManager.Tab?

    var body: some View {
        Form {
            Section("User Agent") {
                TextField("Custom User Agent", text: $utilities.userAgent)
                    .textFieldStyle(.roundedBorder)
            }

            Section("Statistics") {
                LabeledContent("Reading Time", value: formatTime(utilities.readingTime))
            }

            Section("Tools") {
                Button("Capture Screenshot") {
                    if let tab = activeTab {
                        Task {
                            if let image = await utilities.captureScreenshot(of: tab.webPage.webView) {
                                // Save image to disk or photos
                                Logger.shared.info("Screenshot captured successfully")
                            }
                        }
                    }
                }
                .disabled(activeTab == nil)

                #if os(iOS)
                Button("Generate QR Code") {
                    if let url = activeTab?.webPage.url {
                        let _ = utilities.generateQRCode(from: url.absoluteString)
                        // Display QR code in a sheet
                    }
                }
                .disabled(activeTab == nil)
                #endif
            }
        }
        .navigationTitle("Browser Tools")
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: seconds) ?? "0:00"
    }
}
