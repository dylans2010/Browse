import Foundation

final class AITokenEstimator {
    /// Estimates token count based on string length (approximate).
    func estimateTokens(for text: String) -> Int {
        return text.count / 4
    }
}
