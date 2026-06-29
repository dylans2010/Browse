import SwiftUI

struct TabSwitcher: View {
    @Bindable var tabManager: TabManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    ForEach(tabManager.tabs) { tab in
                        VStack {
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.secondary.opacity(0.1))
                                    .frame(height: 120)
                                    .overlay(
                                        Text(tab.webPage.title)
                                            .font(.caption)
                                            .padding()
                                    )

                                Button(action: { tabManager.closeTab(id: tab.id) }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                                .padding(4)
                            }

                            Text(tab.webPage.title.isEmpty ? "New Tab" : tab.webPage.title)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                        .onTapGesture {
                            tabManager.selectTab(id: tab.id)
                            dismiss()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Tabs")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        tabManager.createTab(url: URL(string: "https://www.google.com"), profileId: UUID())
                        dismiss()
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
