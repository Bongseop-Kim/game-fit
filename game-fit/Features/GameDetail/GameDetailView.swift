import SwiftUI
import SwiftData

struct GameDetailView: View {
    let game: GameMeta
    var initialDifficulty: Difficulty = .normal

    @State private var selectedDifficulty: Difficulty = .normal
    @State private var showCountdown = false
    @State private var navigateToPlay = false
    @Query private var allSessions: [GameSession]
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context

    init(game: GameMeta, initialDifficulty: Difficulty = .normal) {
        self.game = game
        self.initialDifficulty = initialDifficulty
        _selectedDifficulty = State(initialValue: initialDifficulty)
    }

    private var bestSession: GameSession? {
        allSessions
            .filter { $0.gameId == game.id && $0.difficulty == selectedDifficulty.rawValue }
            .max(by: { $0.accuracy < $1.accuracy })
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DS.sectionSpacing) {
                heroImage
                infoCard
                difficultySection
                recordCard
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle(game.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(title: "훈련 시작") { showCountdown = true }
                .padding()
                .background(.regularMaterial)
        }
        .overlay {
            if showCountdown {
                CountdownOverlay {
                    showCountdown = false
                    navigateToPlay = true
                }
            }
        }
        .navigationDestination(isPresented: $navigateToPlay) {
            GamePlayView(game: game, difficulty: selectedDifficulty)
        }
    }

    private var heroImage: some View {
        GameImageView(
            imageName: "game_\(game.id)",
            fallbackSymbol: game.sfSymbol,
            fallbackFontSize: 52
        )
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: DS.cardRadius))
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("규칙 안내")
                .font(.appHeadline)
                .foregroundStyle(Color.appTextPrimary)
            Text(game.description)
                .font(.appBody)
                .foregroundStyle(Color.appTextSecondary)
            Text("라운드 수: 10 · 제한 시간: 게임별 상이")
                .font(.appCaption)
                .foregroundStyle(Color.appTextDisabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.cardPadding)
        .cardStyle()
    }

    private var difficultySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("난이도 선택")
                .font(.appHeadline)
                .foregroundStyle(Color.appTextPrimary)
            DifficultyPicker(selected: $selectedDifficulty)
        }
    }

    private var recordCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("최고 기록")
                .font(.appHeadline)
                .foregroundStyle(Color.appTextPrimary)
            if let best = bestSession {
                HStack {
                    Label(String(format: "정확도 %.0f%%", best.accuracy * 100),
                          systemImage: "target")
                    Spacer()
                    Label(String(format: "반응속도 %.1fs", best.avgResponseTime),
                          systemImage: "timer")
                }
                .font(.appBody)
                .foregroundStyle(Color.appTextSecondary)
            } else {
                Text("아직 기록이 없어요")
                    .font(.appBody)
                    .foregroundStyle(Color.appTextDisabled)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.cardPadding)
        .cardStyle()
    }
}

#Preview {
    NavigationStack {
        GameDetailView(game: GameMeta.all[0])
            .environment(AppState())
            .modelContainer(for: [GameSession.self, UserSettings.self], inMemory: true)
    }
}
