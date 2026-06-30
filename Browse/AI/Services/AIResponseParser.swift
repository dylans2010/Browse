import Foundation

final class AIResponseParser {
    func parse(_ response: String) -> String {
        return response.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
