import Foundation
import Observation

@Observable
final class AISettings {
    var isAIEnabled: Bool {
        didSet { UserDefaults.standard.set(isAIEnabled, forKey: kAIEnabled) }
    }
    var showAISidebar: Bool {
        didSet { UserDefaults.standard.set(showAISidebar, forKey: kShowSidebar) }
    }
    var preferredModel: String {
        didSet { UserDefaults.standard.set(preferredModel, forKey: kPreferredModel) }
    }

    private let kAIEnabled = "AISettings.isAIEnabled"
    private let kShowSidebar = "AISettings.showAISidebar"
    private let kPreferredModel = "AISettings.preferredModel"

    init() {
        self.isAIEnabled = UserDefaults.standard.object(forKey: kAIEnabled) as? Bool ?? true
        self.showAISidebar = UserDefaults.standard.object(forKey: kShowSidebar) as? Bool ?? true
        self.preferredModel = UserDefaults.standard.string(forKey: kPreferredModel) ?? "openai/gpt-3.5-turbo"
    }
}
