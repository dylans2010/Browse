import SwiftUI

struct SearchView: View {
    @Bindable var manager = SearchProviderManager.shared

    var body: some View {
        Form {
            Section("Default Search Engine") {
                Picker("Search Engine", selection: $manager.selectedEngineId) {
                    ForEach(manager.engines) { engine in
                        Text(name(for: engine)).tag(engine.id)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Search")
        .frame(minWidth: 300)
    }

    private func name(for engine: SearchEngine) -> String {
        return engine.name
    }
}
