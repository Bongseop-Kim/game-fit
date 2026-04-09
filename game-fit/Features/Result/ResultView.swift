import SwiftUI
import SwiftData

struct ResultView: View {
    let game: GameMeta
    let difficulty: Difficulty
    let session: GameSession

    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState
    @Query private var allSessions: [GameSession]

    @State private var isNewRecord = false
    @State private var hasSaved = false

    var body: some View {
        ScrollView {
            VStack(spacing: DS.sectionSpacing) {
                Text("\(game.name) · \(difficulty.displayName)")
                    .font(.appCaption)
                    .foregroundStyle(Color.appTextSecondary)

                GradeBadge(grade: session.grade, size: 88)

                if isNewRecord {
                    HStack(spacing: 6) {
                        Image(systemName: "trophy.fill").foregroundStyle(.yellow)
                        Text(String(format: "최고 기록 갱신! %.0f%%", session.accuracy * 100))
                            .font(.appBody.bold())
                            .foregroundStyle(Color.appTextPrimary)
                    }
                    .padding(DS.cardPadding)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#FEF9C3"))
                    .clipShape(RoundedRectangle(cornerRadius: DS.cardRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.cardRadius)
                            .stroke(Color(hex: "#FEF08A"), lineWidth: 1)
                    )
                }

                MetricStrip(items: [
                    .init(label: "정확도",    value: String(format: "%.0f%%", session.accuracy * 100)),
                    .init(label: "평균 반응", value: String(format: "%.1fs",  session.avgResponseTime)),
                    .init(label: "정답",      value: "\(session.correctCount)개"),
                ])

                VStack(alignment: .leading, spacing: 8) {
                    Text("라운드별 반응속도")
                        .font(.appHeadline)
                        .foregroundStyle(Color.appTextPrimary)
                    BarChart(values: session.roundDetails, incorrectIndices: [])
                }
                .padding(DS.cardPadding)
                .cardStyle()
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                NavigationLink {
                    GamePlayView(game: game, difficulty: difficulty)
                } label: {
                    PrimaryButtonLabel(title: "다시하기")
                }
                .buttonStyle(.plain)

                SecondaryButton(title: difficulty.next != nil ? "다음 난이도" : "최고 난이도") {
                    appState.homePath = NavigationPath()
                }
                .disabled(difficulty.next == nil)
            }
            .padding()
            .background(.regularMaterial)
        }
        .onAppear { saveSessionIfNeeded() }
    }

    private func saveSessionIfNeeded() {
        guard !hasSaved else { return }
        hasSaved = true
        let prevBest = allSessions
            .filter { $0.gameId == game.id && $0.difficulty == difficulty.rawValue }
            .map(\.accuracy).max() ?? 0
        isNewRecord = session.accuracy > prevBest
        context.insert(session)
        appState.refresh(using: context)
    }
}

#Preview {
    let session = GameSession(
        gameId: "rock_paper_scissors",
        difficulty: "normal",
        totalRounds: 10,
        correctCount: 9,
        incorrectCount: 1,
        avgResponseTime: 1.2,
        grade: "A",
        roundDetails: [1.1, 0.9, 1.3, 0.8, 2.1, 1.0, 0.7, 1.5, 0.9, 1.1]
    )
    NavigationStack {
        ResultView(game: GameMeta.all[0], difficulty: .normal, session: session)
            .environment(AppState())
            .modelContainer(for: [GameSession.self, UserSettings.self], inMemory: true)
    }
}
