import Foundation
import Observation

@Observable
final class StartupViewModel {
    private let manager = StartupManager.shared

    var recommendations: [TabItem] = []
    var smartURLs: [URL] = []

    func loadStartupData(for profileId: UUID) {
        recommendations = manager.getRecoveryRecommendations(for: profileId)
        smartURLs = manager.getSmartStartupURLs(for: profileId)
    }
}
