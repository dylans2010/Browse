import SwiftUI

struct AnnotationsViewMacOS: View {
    @State var viewModel: NoteViewModel
    @State private var newNoteContent: String = ""
    var currentHost: String

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.content)
                        Text(note.createdAt, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            HStack {
                TextField("New note...", text: $newNoteContent)
                    .textFieldStyle(.roundedBorder)
                Button("Add") {
                    viewModel.saveNote(host: currentHost, content: newNoteContent)
                    newNoteContent = ""
                }
                .disabled(newNoteContent.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Notes for \(currentHost)")
        .onAppear { viewModel.loadNotes(for: currentHost) }
        .frame(minWidth: 300)
    }
}
