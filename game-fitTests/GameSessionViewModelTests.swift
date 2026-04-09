import XCTest
@testable import game_fit

@MainActor
final class GameSessionViewModelTests: XCTestCase {
    var vm: GameSessionViewModel!
    let game = GameMeta.all[0]  // rock_paper_scissors

    override func setUp() {
        vm = GameSessionViewModel(game: game, difficulty: "normal", totalRounds: 3)
    }

    override func tearDown() {
        vm = nil
    }

    func test_initialState() {
        XCTAssertEqual(vm.currentRound, 0)
        XCTAssertEqual(vm.correctCount, 0)
        XCTAssertEqual(vm.incorrectCount, 0)
        XCTAssertFalse(vm.isComplete)
        XCTAssertFalse(vm.isPaused)
    }

    func test_recordCorrect_incrementsCorrectAndRound() {
        vm.recordResult(correct: true)
        XCTAssertEqual(vm.correctCount, 1)
        XCTAssertEqual(vm.currentRound, 1)
        XCTAssertEqual(vm.incorrectCount, 0)
    }

    func test_recordIncorrect_incrementsIncorrectAndRound() {
        vm.recordResult(correct: false)
        XCTAssertEqual(vm.incorrectCount, 1)
        XCTAssertEqual(vm.currentRound, 1)
    }

    func test_allRounds_setsIsComplete() {
        vm.recordResult(correct: true)
        vm.recordResult(correct: false)
        XCTAssertFalse(vm.isComplete)
        vm.recordResult(correct: true)  // 3rd round = totalRounds
        XCTAssertTrue(vm.isComplete)
    }

    func test_recordResult_afterCompletion_isIgnored() {
        vm.recordResult(correct: true)
        vm.recordResult(correct: true)
        vm.recordResult(correct: true)

        XCTAssertTrue(vm.isComplete)

        vm.recordResult(correct: false)

        XCTAssertEqual(vm.currentRound, 3)
        XCTAssertEqual(vm.correctCount, 3)
        XCTAssertEqual(vm.incorrectCount, 0)
        XCTAssertEqual(vm.roundResponseTimes.count, 3)
    }

    func test_progress_afterOneRound_isOneThird() {
        vm.recordResult(correct: true)
        XCTAssertEqual(vm.progress, 1.0 / 3.0, accuracy: 0.001)
    }

    func test_avgResponseTime_noRoundsRecorded_returnsZero() {
        XCTAssertEqual(vm.avgResponseTime, 0)
    }

    func test_avgResponseTime_afterRecording_isNonNegative() {
        vm.startRound()
        vm.recordResult(correct: true)
        XCTAssertGreaterThanOrEqual(vm.avgResponseTime, 0)
        XCTAssertEqual(vm.roundResponseTimes.count, 1)  // verify response was recorded
    }

    func test_pause_setsPaused() {
        vm.pause()
        XCTAssertTrue(vm.isPaused)
    }

    func test_resume_clearsPaused() {
        vm.pause()
        vm.resume()
        XCTAssertFalse(vm.isPaused)
    }

    func test_restart_resetsAllState() {
        vm.recordResult(correct: true)
        vm.pause()
        vm.restart()
        XCTAssertEqual(vm.currentRound, 0)
        XCTAssertEqual(vm.correctCount, 0)
        XCTAssertFalse(vm.isPaused)
        XCTAssertFalse(vm.isComplete)
        XCTAssertTrue(vm.roundResponseTimes.isEmpty)
        XCTAssertEqual(vm.elapsedSeconds, 0)
        XCTAssertEqual(vm.incorrectCount, 0)
    }

    func test_buildSession_returnsCorrectFields() {
        vm.recordResult(correct: true)
        vm.recordResult(correct: false)
        vm.recordResult(correct: true)
        let session = vm.buildSession(grade: "B")
        XCTAssertEqual(session.gameId, game.id)
        XCTAssertEqual(session.difficulty, "normal")
        XCTAssertEqual(session.totalRounds, 3)
        XCTAssertEqual(session.correctCount, 2)
        XCTAssertEqual(session.incorrectCount, 1)
        XCTAssertEqual(session.grade, "B")
        XCTAssertEqual(session.roundDetails.count, 3)
    }
}
