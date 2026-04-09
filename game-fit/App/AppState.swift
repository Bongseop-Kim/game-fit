import Foundation
import SwiftUI
import SwiftData
import Observation

@Observable
final class AppState {
    var homePath = NavigationPath()
    private(set) var totalSessions: Int = 0
    private(set) var streak: Int = 0
    private(set) var overallGrade: String = "-"   // 추후 게임별 로직으로 대체
    @ObservationIgnored private var lastRefreshKey: RefreshKey?

    func refresh(using context: ModelContext, now: Date = .now) {
        let sessionCount = fetchTotalSessions(context)
        let refreshDay = Calendar.current.startOfDay(for: now)
        let refreshKey = RefreshKey(sessionCount: sessionCount, refreshDay: refreshDay)

        guard lastRefreshKey != refreshKey else { return }

        totalSessions = sessionCount
        streak = computeStreak(context, now: now)
        overallGrade = computeOverallGrade(totalSessions: sessionCount, streak: streak)
        lastRefreshKey = refreshKey
    }

    // MARK: private

    private struct RefreshKey: Equatable {
        let sessionCount: Int
        let refreshDay: Date
    }

    private func fetchTotalSessions(_ context: ModelContext) -> Int {
        do {
            return try context.fetchCount(FetchDescriptor<GameSession>())
        } catch {
            assertionFailure("fetchTotalSessions failed: \(error)")
            return 0
        }
    }

    private func computeStreak(_ context: ModelContext, now: Date) -> Int {
        let descriptor = FetchDescriptor<GameSession>(
            sortBy: [SortDescriptor(\.playedAt, order: .reverse)]
        )
        let sessions: [GameSession]
        do {
            sessions = try context.fetch(descriptor)
        } catch {
            assertionFailure("computeStreak fetch failed: \(error)")
            return 0
        }
        guard !sessions.isEmpty else { return 0 }

        let calendar = Calendar.current
        let sessionDays = Set(sessions.map { calendar.startOfDay(for: $0.playedAt) })

        var count = 0
        var checkDate = calendar.startOfDay(for: now)
        while sessionDays.contains(checkDate) {
            count += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = prev
        }
        return count
    }

    private func computeOverallGrade(totalSessions: Int, streak: Int) -> String {
        switch (totalSessions, streak) {
        case (20..., 7...):
            return "A"
        case (10..., 3...):
            return "B"
        case (1..., _):
            return "C"
        default:
            return "-"
        }
    }
}
