import Foundation
import SwiftData
import Observation

@Observable
final class CustomSiteManager {
    static let shared = CustomSiteManager()
    private let context = PersistenceProvider.shared.mainContext

    func getConfig(for host: String) -> CustomSiteConfig {
        let descriptor = FetchDescriptor<CustomSiteConfig>(
            predicate: #Predicate { $0.host == host }
        )
        if let config = (try? context.fetch(descriptor))?.first {
            return config
        } else {
            let newConfig = CustomSiteConfig(host: host)
            context.insert(newConfig)
            try? context.save()
            return newConfig
        }
    }

    func saveConfig() {
        try? context.save()
    }
}
