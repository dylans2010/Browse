import SwiftUI
import SwiftData

struct ReadingListView: View {
    @State private var viewModel = ReadingListViewModel()
    @State private var isShowingAddSheet = false
    @State private var newURLString = ""
    @State private var newTitle = ""

    var body: some View {
        List {
            if viewModel.items.isEmpty {
                ContentUnavailableView(
                    "No Reading List Items",
                    systemImage: "book",
                    description: Text("Save pages here to read them later.")
                )
            } else {
                ForEach(viewModel.items) { item in
                    ReadingListRow(
                        item: item,
                        toggleRead: { viewModel.toggleRead(item) },
                        remove: { viewModel.remove(item) }
                    )
                }
            }
        }
        .navigationTitle("Reading List")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            NavigationStack {
                Form {
                    Section("Page") {
                        TextField("Title", text: $newTitle)
                        TextField("URL", text: $newURLString)
                            .urlEntryInputStyle()
                    }
                }
                .navigationTitle("Add to Reading List")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            resetAddForm()
                            isShowingAddSheet = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            addItem()
                        }
                        .disabled(parsedURL == nil || newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadItems()
        }
    }

    private var parsedURL: URL? {
        let trimmed = newURLString.trimmingCharacters(in: .whitespacesAndNewlines)
        return URL(string: trimmed)
    }

    private func addItem() {
        guard let url = parsedURL else { return }
        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.add(url: url, title: title)
        resetAddForm()
        isShowingAddSheet = false
    }

    private func resetAddForm() {
        newURLString = ""
        newTitle = ""
    }
}

private struct ReadingListRow: View {
    let item: ReadingListItem
    let toggleRead: () -> Void
    let remove: () -> Void

    private var bookmarkImageName: String {
        item.isRead ? "bookmark" : "bookmark.fill"
    }

    private var bookmarkColor: Color {
        item.isRead ? .secondary : .blue
    }

    private var titleColor: Color {
        item.isRead ? .secondary : .primary
    }

    private var readActionTitle: String {
        item.isRead ? "Unread" : "Read"
    }

    private var readActionImageName: String {
        item.isRead ? "bookmark" : "bookmark.fill"
    }

    private var readActionTint: Color {
        item.isRead ? .orange : .green
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: bookmarkImageName)
                .foregroundStyle(bookmarkColor)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(titleColor)
                Text(item.url.absoluteString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            if item.isRead {
                Text("Read")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: toggleRead)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: remove) {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button(action: toggleRead) {
                Label(readActionTitle, systemImage: readActionImageName)
            }
            .tint(readActionTint)
        }
    }
}


private extension View {
    @ViewBuilder
    func urlEntryInputStyle() -> some View {
#if os(iOS)
        self
            .textInputAutocapitalization(.never)
            .keyboardType(.URL)
            .autocorrectionDisabled()
#else
        self
            .autocorrectionDisabled()
#endif
    }
}
