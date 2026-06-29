import SwiftUI

struct StartPageView: View {
    @State private var viewModel = StartPageViewModel()
    var onOpenURL: (URL) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text(LocalizedStringKey("GOOD_MORNING"))
                    .font(.largeTitle.bold())
                    .padding(.top, 50)

                if viewModel.showTopSites {
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey("TOP_SITES")).font(.headline)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                            ForEach(viewModel.topSites, id: \.self) { url in
                                Button(action: { onOpenURL(url) }) {
                                    VStack {
                                        Image(systemName: "globe")
                                            .font(.largeTitle)
                                            .frame(width: 60, height: 60)
                                            .background(Color.secondary.opacity(0.2))
                                            .cornerRadius(12)
                                        Text(url.host ?? "Unknown").font(.caption).lineLimit(1)
                                    }
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Open \(url.host ?? "website")")
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
