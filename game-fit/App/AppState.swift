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

    func refresh(using context: ModelContext) {
        totalSessions = fetchTotalSessions(context)
        streak = computeStreak(context)
        // overallGrade: 게임별 등급 산정 로직 TBD — 현재 "-" 유지
    }

    // MARK: private

    private func fetchTotalSessions(_ context: ModelContext) -> Int {
        do {
            return try context.fetchCount(FetchDescriptor<GameSession>())
        } catch {
            assertionFailure("fetchTotalSessions failed: \(error)")
            return 0
        }
    }

    private func computeStreak(_ context: ModelContext) -> Int {
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
        var checkDate = calendar.startOfDay(for: .now)
        while sessionDays.contains(checkDate) {
            count += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = prev
        }
        return count
    }
}
