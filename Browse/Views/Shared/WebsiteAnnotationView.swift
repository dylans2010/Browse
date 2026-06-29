import SwiftUI
import SwiftData

struct WebsiteAnnotationView: View {
    let url: URL
    let profileId: UUID
    @Query private var notes: [WebsiteNote]
    @Environment(\.modelContext) private var context

    @State private var newNoteText: String = ""

    init(url: URL, profileId: UUID) {
        self.url = url
        self.profileId = profileId
        let urlString = url.absoluteString
        self._notes = Query(filter: #Predicate<WebsiteNote> { $0.url.absoluteString == urlString })
    }

    var body: some View {
        VStack {
            List(notes) { note in
                Text(note.content)
            }

            HStack {
                TextField("Add a note...", text: $newNoteText)
                    .textFieldStyle(.roundedBorder)
                Button("Add") {
                    let note = WebsiteNote(url: url, content: newNoteText, profileId: profileId)
                    context.insert(note)
                    newNoteText = ""
                    try? context.save()
                }
            }
            .padding()
        }
        .navigationTitle("Website Notes")
    }
}
