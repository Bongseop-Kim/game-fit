import XCTest
import SwiftData
@testable import game_fit

@MainActor
final class AppStateTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    var appState: AppState!
    private var testNow: Date!

    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: GameSession.self,
            configurations: config
        )
        context = ModelContext(container)
        testNow = Calendar.current.date(from: DateComponents(
            year: 2026,
            month: 4,
            day: 9,
            hour: 12
        ))!
        appState = AppState()
    }

    override func tearDown() async throws {
        appState = nil
        context = nil
        container = nil
    }

    // MARK: totalSessions

    func test_totalSessions_emptyDatabase_returnsZero() {
        appState.refresh(using: context, now: testNow)
        XCTAssertEqual(appState.totalSessions, 0)
    }

    func test_totalSessions_afterOneInsert_returnsOne() throws {
        context.insert(makeSession())
        try context.save()
        appState.refresh(using: context, now: testNow)
        XCTAssertEqual(appState.totalSessions, 1)
    }

    func test_totalSessions_afterThreeInserts_returnsThree() throws {
        context.insert(makeSession())
        context.insert(makeSession())
        context.insert(makeSession())
        try context.save()
        appState.refresh(using: context, now: testNow)
        XCTAssertEqual(appState.totalSessions, 3)
    }

    // MARK: streak

    func test_streak_noSessions_returnsZero() {
        appState.refresh(using: context, now: testNow)
        XCTAssertEqual(appState.streak, 0)
    }

    func test_streak_onlyYesterday_returnsZero() throws {
        context.insert(makeSession(daysAgo: 1))  // yesterday only, no today
        try context.save()
        appState.refresh(using: context, now: testNow)
        XCTAssertEqual(appState.streak, 0)  // current streak requires today
    }

    func test_streak_sessionToday_returnsOne() throws {
        context.insert(makeSession(daysAgo: 0))
        try context.save()
        appState.refresh(using: context, now: testNow)
        XCTAssertEqual(appState.streak, 1)
    }

    func test_streak_consecutiveTwoDays_returnsTwo() throws {
        context.insert(makeSession(daysAgo: 0))
        context.insert(makeSession(daysAgo: 1))
        try context.save()
        appState.refresh(using: context, now: testNow)
        XCTAssertEqual(appState.streak, 2)
    }

    func test_streak_gapInDays_countsFromToday() throws {
        context.insert(makeSession(daysAgo: 0))
        context.insert(makeSession(daysAgo: 2))  // gap on day 1
        try context.save()
        appState.refresh(using: context, now: testNow)
        XCTAssertEqual(appState.streak, 1)  // gap breaks streak
    }

    func test_overallGrade_afterSessions_isNotPlaceholder() throws {
        context.insert(makeSession(daysAgo: 0))
        context.insert(makeSession(daysAgo: 1))
        try context.save()

        appState.refresh(using: context, now: testNow)

        XCTAssertNotEqual(appState.overallGrade, "-")
    }

    // MARK: helpers

    private func makeSession(daysAgo: Int = 0) -> GameSession {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: testNow)!
        return GameSession(
            gameId: "rock_paper_scissors",
            difficulty: "normal",
            playedAt: date,
            totalRounds: 10,
            correctCount: 8,
            incorrectCount: 2,
            avgResponseTime: 1.5,
            grade: "A",
            roundDetails: []
        )
    }
}
