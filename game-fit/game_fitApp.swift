import SwiftUI
import SwiftData

@main
struct game_fitApp: App {
    private let appState = AppState()
    private let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: GameSession.self, UserSettings.self)
            let context = ModelContext(container)
            let count = try context.fetchCount(FetchDescriptor<UserSettings>())
            if count == 0 {
                context.insert(UserSettings())
                try context.save()
            }
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
        }
        .modelContainer(container)
    }
}

struct RootView: View {
    @Query private var settingsArray: [UserSettings]

    var body: some View {
        if let settings = settingsArray.first {
            if settings.isOnboardingComplete {
                MainTabView()
            } else {
                OnboardingView(settings: settings)
            }
        } else {
            ProgressView()
        }
    }
}
