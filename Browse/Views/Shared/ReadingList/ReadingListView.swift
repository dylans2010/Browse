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
                    HStack(spacing: 12) {
                        Image(systemName: item.isRead ? "bookmark" : "bookmark.fill")
                            .foregroundStyle(item.isRead ? .secondary : .blue)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                                .foregroundStyle(item.isRead ? .secondary : .primary)
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
                    .onTapGesture {
                        viewModel.toggleRead(item)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.remove(item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.toggleRead(item)
                        } label: {
                            Label(item.isRead ? "Unread" : "Read", systemImage: item.isRead ? "bookmark" : "bookmark.fill")
                        }
                        .tint(item.isRead ? .orange : .green)
                    }
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
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                            .autocorrectionDisabled()
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
