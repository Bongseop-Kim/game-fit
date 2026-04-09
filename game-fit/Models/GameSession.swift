import Foundation
import SwiftData

@Model
final class GameSession {
    var gameId: String
    var difficulty: String
    var playedAt: Date
    var totalRounds: Int
    var correctCount: Int
    var incorrectCount: Int
    var avgResponseTime: Double   // 초 단위
    var grade: String             // "A"~"F"
    // Stored as JSON-encoded Data for SwiftData compatibility
    var roundDetailsData: Data = Data()

    // Public interface — not persisted
    var roundDetails: [Double] {
        get { (try? JSONDecoder().decode([Double].self, from: roundDetailsData)) ?? [] }
        set { roundDetailsData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    init(
        gameId: String,
        difficulty: String,
        playedAt: Date = .now,
        totalRounds: Int,
        correctCount: Int,
        incorrectCount: Int,
        avgResponseTime: Double,
        grade: String,
        roundDetails: [Double]
    ) {
        self.gameId = gameId
        self.difficulty = difficulty
        self.playedAt = playedAt
        self.totalRounds = totalRounds
        self.correctCount = correctCount
        self.incorrectCount = incorrectCount
        self.avgResponseTime = avgResponseTime
        self.grade = grade
        // Encode roundDetails to Data during init
        self.roundDetailsData = (try? JSONEncoder().encode(roundDetails)) ?? Data()
    }

    var accuracy: Double {
        guard totalRounds > 0 else { return 0 }
        return Double(correctCount) / Double(totalRounds)
    }
}
