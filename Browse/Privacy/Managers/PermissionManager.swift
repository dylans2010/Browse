import Foundation
import SwiftData
import Observation

@Observable
final class PermissionManager {
    static let shared = PermissionManager()
    private let context = PersistenceProvider.shared.mainContext

    var permissions: [SitePermission] = []

    func fetchPermissions(for host: String? = nil) {
        let descriptor = FetchDescriptor<SitePermission>(
            predicate: host != nil ? #Predicate { $0.host == host! } : nil
        )
        permissions = (try? context.fetch(descriptor)) ?? []
    }

    func updatePermission(host: String, type: String, state: String) {
        if let existing = permissions.first(where: { $0.host == host && $0.permissionType == type }) {
            existing.state = state
        } else {
            let newPerm = SitePermission(host: host, permissionType: type, state: state)
            context.insert(newPerm)
        }
        try? context.save()
        fetchPermissions(for: host)
    }
}
