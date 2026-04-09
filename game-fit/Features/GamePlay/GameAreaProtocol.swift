import SwiftUI

protocol GameArea: View {
    var viewModel: GameSessionViewModel { get }
}

// 앱 쉘용 플레이스홀더 — 게임별 UI 구현 전까지 사용
struct PlaceholderGameArea: GameArea {
    @Bindable var viewModel: GameSessionViewModel

    var body: some View {
        VStack(spacing: 32) {
            Text("게임 영역")
                .font(.appHeadline)
                .foregroundStyle(.secondary)

            Text("\(viewModel.currentRound + 1) / \(viewModel.totalRounds) 라운드")
                .font(.appBody)
                .foregroundStyle(.secondary)

            HStack(spacing: 20) {
                Button {
                    viewModel.recordResult(correct: true)
                } label: {
                    Label("정답", systemImage: "checkmark.circle.fill")
                        .font(.appBody.bold())
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                Button {
                    viewModel.recordResult(correct: false)
                } label: {
                    Label("오답", systemImage: "xmark.circle")
                        .font(.appBody)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.bordered)
            }
        }
        .onAppear { viewModel.startRound() }
        .onChange(of: viewModel.currentRound) { _, _ in
            guard !viewModel.isComplete else { return }
            viewModel.startRound()
        }
    }
}

#Preview {
    PlaceholderGameArea(viewModel: GameSessionViewModel(
        game: GameMeta.all[0],
        difficulty: "normal",
        totalRounds: 5
    ))
}
