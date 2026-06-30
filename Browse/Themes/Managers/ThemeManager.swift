import Foundation
import SwiftData
import Observation

@Observable
final class ThemeManager {
    static let shared = ThemeManager()
    private let context = PersistenceProvider.shared.mainContext

    func getConfiguration(for profileId: UUID) -> UIConfiguration {
        let descriptor = FetchDescriptor<UIConfiguration>(
            predicate: #Predicate { $0.profileId == profileId }
        )
        if let config = (try? context.fetch(descriptor))?.first {
            return config
        } else {
            let newConfig = UIConfiguration(profileId: profileId)
            context.insert(newConfig)
            try? context.save()
            return newConfig
        }
    }

    func saveConfiguration() {
        try? context.save()
    }
}
