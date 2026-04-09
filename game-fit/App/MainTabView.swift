import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context

    var body: some View {
        TabView {
            NavigationStack(path: Bindable(appState).homePath) {
                HomeView()
            }
            .tabItem { Label("홈", systemImage: "house.fill") }

            NavigationStack {
                RecordsView()
            }
            .tabItem { Label("기록", systemImage: "chart.bar.fill") }

            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("설정", systemImage: "gearshape.fill") }
        }
        .task { appState.refresh(using: context) }
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
        .modelContainer(for: [GameSession.self, UserSettings.self], inMemory: true)
}
