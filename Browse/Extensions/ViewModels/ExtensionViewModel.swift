import Foundation
import Observation

@Observable
final class ExtensionViewModel {
    private let manager = ExtensionManager.shared
    private let generator = ExtensionGenerator.shared

    var extensions: [BrowserExtension] { manager.extensions }
    var isGenerating: Bool = false

    func loadExtensions() {
        manager.fetchExtensions()
    }

    func generate(description: String) async {
        isGenerating = true
        defer { isGenerating = false }
        do {
            let result = try await generator.generateExtension(from: description)
            manager.installExtension(name: result.name, script: result.script, manifest: result.manifest)
        } catch {
            LoggingService.shared.error("Failed to generate extension", error: error)
        }
    }
}
