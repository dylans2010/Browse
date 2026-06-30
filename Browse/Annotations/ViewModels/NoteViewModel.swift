import Foundation
import Observation

@Observable
final class NoteViewModel {
    private let manager = NoteManager.shared

    var notes: [WebsiteNote] { manager.notes }

    func loadNotes(for host: String? = nil) {
        manager.fetchNotes(for: host)
    }

    func saveNote(host: String, content: String) {
        manager.addNote(host: host, content: content)
    }
}
