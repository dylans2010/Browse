import Foundation
import SwiftData
import Observation

@Observable
final class NoteManager {
    static let shared = NoteManager()
    private let context = PersistenceProvider.shared.mainContext

    var notes: [WebsiteNote] = []

    func fetchNotes(for host: String? = nil) {
        let descriptor = FetchDescriptor<WebsiteNote>(
            predicate: host != nil ? #Predicate { $0.host == host! } : nil
        )
        notes = (try? context.fetch(descriptor)) ?? []
    }

    func addNote(host: String, content: String) {
        let note = WebsiteNote(host: host, content: content)
        context.insert(note)
        try? context.save()
        fetchNotes(for: host)
    }
}
