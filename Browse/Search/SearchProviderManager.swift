import Foundation
import Observation

struct SearchEngine: Identifiable, Codable {
    let id: UUID
    var name: String
    var searchURL: String
    var suggestionURL: String?

    static let builtIn: [SearchEngine] = [
        SearchEngine(id: UUID(), name: "Google", searchURL: "https://www.google.com/search?q=%s"),
        SearchEngine(id: UUID(), name: "DuckDuckGo", searchURL: "https://duckduckgo.com/?q=%s"),
        SearchEngine(id: UUID(), name: "Brave", searchURL: "https://search.brave.com/search?q=%s"),
        SearchEngine(id: UUID(), name: "Bing", searchURL: "https://www.bing.com/search?q=%s")
    ]
}

@Observable
final class SearchProviderManager {
    static let shared = SearchProviderManager()
    private let kSelectedEngineId = "SearchProviderManager.selectedEngineId"

    var engines: [SearchEngine] = SearchEngine.builtIn
    var selectedEngineId: UUID {
        didSet {
            UserDefaults.standard.set(selectedEngineId.uuidString, forKey: kSelectedEngineId)
        }
    }

    init() {
        if let idString = UserDefaults.standard.string(forKey: kSelectedEngineId),
           let uuid = UUID(uuidString: idString) {
            self.selectedEngineId = uuid
        } else {
            self.selectedEngineId = SearchEngine.builtIn[0].id
        }
    }

    var selectedEngine: SearchEngine {
        engines.first { $0.id == selectedEngineId } ?? engines[0]
    }

    func searchURL(for query: String) -> URL? {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = selectedEngine.searchURL.replacingOccurrences(of: "%s", with: encodedQuery)
        return URL(string: urlString)
    }
}
