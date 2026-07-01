import SwiftUI
import WebKit

struct SecurityViewIOS: View {
    @State var viewModel = SecurityViewModel()
    var webView: WKWebView?

    var body: some View {
        List {
            Section("Cookies") {
                if viewModel.cookies.isEmpty {
                    Text("No cookies found").foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.cookies, id: \.name) { cookie in
                        VStack(alignment: .leading) {
                            Text(cookie.name).font(.headline)
                            Text(cookie.domain).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }

            Section("Website Data") {
                ForEach(viewModel.dataRecords, id: \.displayName) { record in
                    Text(record.displayName)
                }
            }
        }
        .navigationTitle("Security & Privacy")
        .task {
            if let webView = webView {
                await viewModel.refresh(webView: webView)
            }
        }
    }
}
