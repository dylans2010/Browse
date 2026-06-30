import Foundation
import Observation

@Observable
final class PermissionViewModel {
    private let manager = PermissionManager.shared

    var permissions: [SitePermission] { manager.permissions }

    func loadPermissions(for host: String? = nil) {
        manager.fetchPermissions(for: host)
    }

    func setPermission(host: String, type: String, state: String) {
        manager.updatePermission(host: host, type: type, state: state)
    }
}
