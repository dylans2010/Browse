import Foundation
import SwiftData
import Observation

@Observable
final class HomepageManager {
    static let shared = HomepageManager()
    private let context = PersistenceProvider.shared.mainContext

    func getConfig(for profileId: UUID) -> HomepageConfig {
        let descriptor = FetchDescriptor<HomepageConfig>(
            predicate: #Predicate { $0.profileId == profileId }
        )
        if let config = (try? context.fetch(descriptor))?.first {
            return config
        } else {
            let newConfig = HomepageConfig(profileId: profileId)
            context.insert(newConfig)
            try? context.save()
            return newConfig
        }
    }

    func saveConfig() {
        try? context.save()
    }
}
