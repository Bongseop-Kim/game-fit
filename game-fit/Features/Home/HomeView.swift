import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Query private var allSessions: [GameSession]

    private let reactionGames  = GameMeta.games(for: .reaction)
    private let memoryGames    = GameMeta.games(for: .memory)
    private let judgmentGames  = GameMeta.games(for: .judgment)

    private let twoColumns   = [GridItem(.flexible()), GridItem(.flexible())]
    private let threeColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        let bestGrades = Dictionary(grouping: allSessions, by: \.gameId)
            .compactMapValues { $0.max(by: { $0.accuracy < $1.accuracy })?.grade }
        return ScrollView {
            VStack(alignment: .leading, spacing: DS.sectionSpacing) {
                MetricStrip(items: [
                    .init(label: "총 훈련",   value: "\(appState.totalSessions)"),
                    .init(label: "연속",      value: "\(appState.streak)일"),
                    .init(label: "종합등급",  value: appState.overallGrade, valueColor: Color.appPrimary),
                ])

                sectionHeader("반응속도")
                LazyVGrid(columns: twoColumns, spacing: 10) {
                    ForEach(reactionGames) { game in
                        NavigationLink(value: game) {
                            GameCard(game: game, bestGrade: bestGrades[game.id])
                        }
                        .buttonStyle(.plain)
                    }
                }

                sectionHeader("기억력")
                LazyVGrid(columns: twoColumns, spacing: 10) {
                    ForEach(memoryGames) { game in
                        NavigationLink(value: game) {
                            GameCard(game: game, bestGrade: bestGrades[game.id])
                        }
                        .buttonStyle(.plain)
                    }
                }

                sectionHeader("판단력")
                LazyVGrid(columns: twoColumns, spacing: 10) {
                    ForEach(judgmentGames) { game in
                        NavigationLink(value: game) {
                            GameCard(game: game, bestGrade: bestGrades[game.id])
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle("AI 면접 훈련")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: GameMeta.self) { game in
            GameDetailView(game: game)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.appSectionLabel)
            .foregroundStyle(Color.appTextSecondary)
            .tracking(0.5)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environment(AppState())
            .modelContainer(for: [GameSession.self, UserSettings.self], inMemory: true)
    }
}
