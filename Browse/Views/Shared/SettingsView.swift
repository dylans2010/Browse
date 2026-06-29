import SwiftUI

struct SettingsView: View {
    @Bindable var aiSettings: AISettings
    @State private var viewModel: AISettingsViewModel

    init(aiSettings: AISettings) {
        self.aiSettings = aiSettings
        self._viewModel = State(initialValue: AISettingsViewModel(aiSettings: aiSettings))
    }

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem { Label(LocalizedStringKey("GENERAL"), systemImage: "gearshape") }

            AISettingsTab(viewModel: viewModel)
                .tabItem { Label("AI", systemImage: "sparkles") }
        }
        .frame(width: 450, height: 300)
        .padding()
    }
}

struct GeneralSettingsView: View {
    var body: some View {
        Form {
            Text(LocalizedStringKey("GENERAL"))
        }
    }
}

struct AISettingsTab: View {
    @Bindable var viewModel: AISettingsViewModel

    var body: some View {
        Form {
            Toggle("Enable AI Features", isOn: $viewModel.aiSettings.isAIEnabled)

            SecureField("OpenRouter API Key", text: $viewModel.apiKey)
                .textFieldStyle(.roundedBorder)

            Button(LocalizedStringKey("SAVE")) {
                viewModel.save()
            }
            .buttonStyle(.borderedProminent)

            Picker("Preferred Model", selection: $viewModel.aiSettings.preferredModel) {
                Text("GPT-3.5 Turbo").tag("openai/gpt-3.5-turbo")
                Text("GPT-4 Turbo").tag("openai/gpt-4-turbo")
                Text("Claude 3 Opus").tag("anthropic/claude-3-opus")
            }
        }
    }
}
