import SwiftUI

struct BookmarkManagerView: View {
    @State private var viewModel = LibraryViewModel()

    var body: some View {
        List {
            ForEach(viewModel.bookmarks) { bookmark in
                HStack {
                    Image(systemName: "bookmark.fill")
                    VStack(alignment: .leading) {
                        Text(bookmark.title).font(.headline)
                        Text(bookmark.url.absoluteString).font(.caption).foregroundColor(.secondary)
                    }
                }
                .contextMenu {
                    Button("Delete", role: .destructive) {
                        viewModel.deleteBookmark(bookmark)
                    }
                }
            }
        }
        .navigationTitle("Bookmarks")
        .onAppear { viewModel.fetchAll() }
    }
}

struct HistoryManagerView: View {
    @State private var viewModel = LibraryViewModel()

    var body: some View {
        List {
            ForEach(viewModel.history) { item in
                HStack {
                    Image(systemName: "clock")
                    VStack(alignment: .leading) {
                        Text(item.title).font(.headline)
                        Text(item.url.absoluteString).font(.caption).foregroundColor(.secondary)
                    }
                }
            }
        }
        .toolbar {
            Button("Clear History") {
                viewModel.clearHistory()
            }
        }
        .navigationTitle("History")
        .onAppear { viewModel.fetchAll() }
    }
}

struct DownloadManagerView: View {
    @State private var viewModel = LibraryViewModel()

    var body: some View {
        List {
            ForEach(viewModel.downloads) { item in
                HStack {
                    Image(systemName: "arrow.down.circle")
                    VStack(alignment: .leading) {
                        Text(item.filename).font(.headline)
                        ProgressView(value: Double(item.receivedBytes), total: Double(item.totalBytes))
                    }
                }
            }
        }
        .navigationTitle("Downloads")
        .onAppear { viewModel.fetchAll() }
    }
}
