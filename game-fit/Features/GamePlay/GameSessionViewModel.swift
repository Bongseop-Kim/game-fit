import Foundation
import Observation
import Combine

@Observable
@MainActor
final class GameSessionViewModel {
    let game: GameMeta
    let difficulty: String
    let totalRounds: Int

    private(set) var currentRound: Int = 0
    private(set) var correctCount: Int = 0
    private(set) var incorrectCount: Int = 0
    private(set) var roundResponseTimes: [Double] = []
    private(set) var isComplete: Bool = false
    private(set) var isPaused: Bool = false
    private(set) var elapsedSeconds: Double = 0  // 현재 라운드 경과 시간 (HUD 타이머)

    private var timerCancellable: AnyCancellable?

    init(game: GameMeta, difficulty: String, totalRounds: Int = 10) {
        self.game = game
        self.difficulty = difficulty
        self.totalRounds = totalRounds
    }

    // MARK: - Public API

    func startRound() {
        elapsedSeconds = 0
        startTimer()
    }

    func recordResult(correct: Bool) {
        let responseTime = elapsedSeconds
        roundResponseTimes.append(responseTime)
        if correct { correctCount += 1 } else { incorrectCount += 1 }
        currentRound += 1
        stopTimer()
        if currentRound >= totalRounds {
            isComplete = true
        }
    }

    func pause() {
        isPaused = true
        stopTimer()
    }

    func resume() {
        isPaused = false
        startTimer()
    }

    func restart() {
        stopTimer()
        currentRound = 0
        correctCount = 0
        incorrectCount = 0
        roundResponseTimes = []
        isComplete = false
        isPaused = false
        elapsedSeconds = 0
        // Session is now in "ready" state — call startRound() to begin the first round.
    }

    func buildSession(grade: String) -> GameSession {
        GameSession(
            gameId: game.id,
            difficulty: difficulty,
            totalRounds: totalRounds,
            correctCount: correctCount,
            incorrectCount: incorrectCount,
            avgResponseTime: avgResponseTime,
            grade: grade,
            roundDetails: roundResponseTimes
        )
    }

    // MARK: - Computed

    var progress: Double {
        guard totalRounds > 0 else { return 0 }
        return Double(currentRound) / Double(totalRounds)
    }

    var avgResponseTime: Double {
        guard !roundResponseTimes.isEmpty else { return 0 }
        return roundResponseTimes.reduce(0, +) / Double(roundResponseTimes.count)
    }

    // MARK: - Private

    private func startTimer() {
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, !self.isPaused else { return }
                self.elapsedSeconds += 0.1
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
