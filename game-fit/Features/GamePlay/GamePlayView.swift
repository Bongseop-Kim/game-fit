import SwiftUI
import SwiftData

struct GamePlayView: View {
    let game: GameMeta
    let difficulty: Difficulty

    @State private var viewModel: GameSessionViewModel
    @State private var showPauseSheet = false
    @State private var completedSession: GameSession?
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @MainActor
    init(game: GameMeta, difficulty: Difficulty) {
        self.game = game
        self.difficulty = difficulty
        _viewModel = State(initialValue: GameSessionViewModel(
            game: game,
            difficulty: difficulty.rawValue,
            totalRounds: 10
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    showPauseSheet = true
                } label: {
                    Image(systemName: "pause.circle.fill")
                        .font(.appHeadline)
                        .foregroundStyle(Color.appTextSecondary)
                }
                .frame(width: 44, height: 44)

                Spacer()

                VStack(spacing: 1) {
                    Text("라운드")
                        .font(.appCaption)
                        .foregroundStyle(Color.appTextSecondary)
                    Text("\(viewModel.currentRound + 1) / \(viewModel.totalRounds)")
                        .font(.appBody.bold())
                        .foregroundStyle(Color.appTextPrimary)
                }

                Spacer()

                VStack(spacing: 1) {
                    Text("경과 시간")
                        .font(.appCaption)
                        .foregroundStyle(Color.appTextSecondary)
                    Text(String(format: "%.1fs", viewModel.elapsedSeconds))
                        .font(.appBody.bold())
                        .foregroundStyle(Color.appPrimary)
                }
                .frame(width: 64, alignment: .trailing)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.appSurface)
            .overlay(alignment: .bottom) {
                Color.appBorder.frame(height: 1)
            }

            GeometryReader { proxy in
                Color.appPrimary
                    .frame(width: proxy.size.width * viewModel.progress)
            }
            .frame(height: 4)
            .background(Color.appBorder)

            HStack(spacing: 20) {
                HStack(spacing: 5) {
                    Circle().fill(Color.gradeColor("A")).frame(width: 8, height: 8)
                    Text("정답 \(viewModel.correctCount)")
                        .font(.appLabel.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                }
                HStack(spacing: 5) {
                    Circle().fill(Color.gradeColor("F")).frame(width: 8, height: 8)
                    Text("오답 \(viewModel.incorrectCount)")
                        .font(.appLabel.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                }
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.appSurface)
            .overlay(alignment: .bottom) {
                Color.appBorder.frame(height: 1)
            }

            PlaceholderGameArea(viewModel: viewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.appBackground)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: .init(
            get: { completedSession != nil },
            set: { if !$0 { completedSession = nil } }
        )) {
            if let session = completedSession {
                ResultView(game: game, difficulty: difficulty, session: session)
            }
        }
        .onChange(of: viewModel.isComplete) { _, isComplete in
            if isComplete { completedSession = viewModel.buildSession(grade: viewModel.grade) }
        }
        .sheet(isPresented: $showPauseSheet) {
            PauseMenuView(
                onResume: { showPauseSheet = false; viewModel.resume() },
                onRestart: { showPauseSheet = false; viewModel.restart() },
                onExit: { showPauseSheet = false; viewModel.pause(); dismiss() }
            )
            .presentationDetents([.fraction(0.35)])
            .interactiveDismissDisabled(true)
        }
        .onChange(of: showPauseSheet) { _, isShowing in
            if isShowing { viewModel.pause() }
        }
    }
}

private struct PauseMenuView: View {
    let onResume: () -> Void
    let onRestart: () -> Void
    let onExit: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("일시정지")
                .font(.appHeadline)
                .foregroundStyle(Color.appTextPrimary)
                .padding(.top)

            PrimaryButton(title: "계속하기", action: onResume)
            SecondaryButton(title: "다시 시작", action: onRestart)

            Button("나가기", action: onExit)
                .font(.appBody)
                .foregroundStyle(Color.gradeColor("F"))
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        GamePlayView(game: GameMeta.all[0], difficulty: .normal)
            .environment(AppState())
            .modelContainer(for: [GameSession.self, UserSettings.self], inMemory: true)
    }
}
