import Foundation
import SwiftData
import Observation

@Observable
final class ExtensionManager {
    static let shared = ExtensionManager()
    private let context = PersistenceProvider.shared.mainContext

    var extensions: [BrowserExtension] = []

    func fetchExtensions() {
        let descriptor = FetchDescriptor<BrowserExtension>()
        extensions = (try? context.fetch(descriptor)) ?? []
    }

    func installExtension(name: String, script: String, manifest: String) {
        let ext = BrowserExtension(name: name, manifestJSON: manifest, scriptSource: script)
        context.insert(ext)
        try? context.save()
        fetchExtensions()
    }

    func deleteExtension(_ ext: BrowserExtension) {
        context.delete(ext)
        try? context.save()
        fetchExtensions()
    }
}
