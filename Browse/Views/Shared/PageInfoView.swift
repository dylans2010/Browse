import SwiftUI

struct PageInfoView: View {
    let url: URL?
    let title: String
    let certificateInfo: String?

    var body: some View {
        Form {
            Section("General") {
                LabeledContent("Title", value: title)
                LabeledContent("URL", value: url?.absoluteString ?? "N/A")
            }

            Section("Security") {
                LabeledContent("Certificate", value: certificateInfo ?? "Unknown")
                if url?.scheme == "https" {
                    Label("Connection is secure", systemImage: "lock.fill").foregroundColor(.green)
                } else {
                    Label("Connection is not secure", systemImage: "exclamationmark.triangle.fill").foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Page Information")
    }
}
