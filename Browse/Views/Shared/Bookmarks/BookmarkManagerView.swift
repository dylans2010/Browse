import SwiftUI
import SwiftData

struct BookmarkManagerView: View {
    @Query(sort: \Bookmark.createdAt, order: .reverse) var bookmarks: [Bookmark]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            ForEach(bookmarks) { bookmark in
                HStack {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text(bookmark.title)
                            .font(.headline)
                        Text(bookmark.url.absoluteString)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    if bookmark.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                .contextMenu {
                    Button("Delete") {
                        modelContext.delete(bookmark)
                    }
                }
            }
        }
        .navigationTitle("Bookmarks")
    }
}
