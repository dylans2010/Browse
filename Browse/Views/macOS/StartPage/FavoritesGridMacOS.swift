#if os(macOS)
import SwiftUI
import SwiftData

struct FavoritesGridMacOS: View {
    @Query(filter: #Predicate<Bookmark> { $0.isFavorite }, sort: \.favoriteSortIndex)
    private var favorites: [Bookmark]
    var onSelect: (URL) -> Void

    let columns = [
        GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 20)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(favorites) { favorite in
                Button(action: { onSelect(favorite.url) }) {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.secondary.opacity(0.1))
                                .frame(width: 60, height: 60)

                            Image(systemName: "globe")
                                .font(.title)
                        }

                        Text(favorite.title)
                            .font(.caption)
                            .lineLimit(1)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}
#endif
