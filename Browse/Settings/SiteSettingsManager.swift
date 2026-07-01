import Foundation
import Observation
import SwiftData

@Observable
final class SiteSettingsManager {
    static let shared = SiteSettingsManager()
    private let context = PersistenceProvider.shared.mainContext

    func getSettings(for host: String) -> SiteSettings {
        let descriptor = FetchDescriptor<SiteSettings>(
            predicate: #Predicate { $0.host == host }
        )
        if let settings = (try? context.fetch(descriptor))?.first {
            return settings
        } else {
            let newSettings = SiteSettings(host: host)
            context.insert(newSettings)
            try? context.save()
            return newSettings
        }
    }

    func saveSettings() {
        try? context.save()
    }
}
