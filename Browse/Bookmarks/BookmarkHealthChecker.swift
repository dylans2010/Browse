import Foundation

final class BookmarkHealthChecker {
    static let shared = BookmarkHealthChecker()

    func checkHealth(url: URL) async -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 10

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                return (200...399).contains(httpResponse.statusCode)
            }
        } catch {
            return false
        }
        return false
    }
}
