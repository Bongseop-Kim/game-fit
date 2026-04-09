import SwiftUI
import SwiftData

struct RecordsView: View {
    @Query(sort: \GameSession.playedAt, order: .reverse) private var allSessions: [GameSession]
    @Environment(AppState.self) private var appState
    @State private var selectedCategory: GameCategory? = nil

    private var filteredSessions: [GameSession] {
        guard let category = selectedCategory else { return allSessions }
        let ids = Set(GameMeta.games(for: category).map(\.id))
        return allSessions.filter { ids.contains($0.gameId) }
    }

    private var chartData: [(date: Date, accuracy: Double)] {
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: .now))!
        let recent = filteredSessions.filter { $0.playedAt >= sevenDaysAgo }
        let grouped = Dictionary(grouping: recent) { calendar.startOfDay(for: $0.playedAt) }
        return grouped
            .map { (date: $0.key, accuracy: $0.value.map(\.accuracy).reduce(0, +) / Double($0.value.count)) }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        let sessionsByGame = Dictionary(grouping: allSessions, by: \.gameId)
        ScrollView {
            VStack(alignment: .leading, spacing: DS.sectionSpacing) {
                MetricStrip(items: [
                    .init(label: "총 훈련",  value: "\(appState.totalSessions)"),
                    .init(label: "연속",     value: "\(appState.streak)일"),
                    .init(label: "종합등급", value: appState.overallGrade, valueColor: Color.appPrimary),
                ])
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        RecordFilterChip(title: "전체", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        ForEach(GameCategory.allCases, id: \.self) { cat in
                            RecordFilterChip(title: cat.displayName, isSelected: selectedCategory == cat) {
                                selectedCategory = (selectedCategory == cat) ? nil : cat
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("종합 정확도 추이 (7일)")
                        .font(.appHeadline)
                        .foregroundStyle(Color.appTextPrimary)
                    if chartData.isEmpty {
                        Text("아직 훈련 기록이 없어요")
                            .font(.appBody)
                            .foregroundStyle(Color.appTextSecondary)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                    } else {
                        LineChart(dataPoints: chartData)
                    }
                }
                .padding(DS.cardPadding)
                .cardStyle()
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("게임별 현황")
                        .font(.appHeadline)
                        .foregroundStyle(Color.appTextPrimary)
                        .padding(.horizontal)

                    ForEach(displayGames) { game in
                        NavigationLink(value: game) {
                            GameRecordRow(game: game, sessions: sessionsByGame[game.id] ?? [])
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color.appBackground)
        .navigationTitle("훈련 기록")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: GameMeta.self) { game in
            GameDetailView(game: game)
        }
    }

    private var displayGames: [GameMeta] {
        guard let category = selectedCategory else { return GameMeta.all }
        return GameMeta.games(for: category)
    }
}

private struct RecordFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appLabel)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.appTextPrimary : Color.appSurface)
                .foregroundStyle(isSelected ? Color.appSurface : Color.appTextSecondary)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(isSelected ? Color.clear : Color.appBorder, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

private struct GameRecordRow: View {
    let game: GameMeta
    let sessions: [GameSession]

    private var bestSession: GameSession? { sessions.max(by: { $0.accuracy < $1.accuracy }) }

    var body: some View {
        HStack(spacing: 12) {
            GameImageView(
                imageName: "game_\(game.id)",
                fallbackSymbol: game.sfSymbol,
                fallbackFontSize: 16
            )
            .frame(width: DS.iconTileSize, height: DS.iconTileSize)
            .clipShape(RoundedRectangle(cornerRadius: DS.iconTileRadius))

            VStack(alignment: .leading, spacing: 2) {
                Text(game.name)
                    .font(.appBody.bold())
                    .foregroundStyle(sessions.isEmpty ? Color.appTextDisabled : Color.appTextPrimary)
                Text(sessions.isEmpty ? "미훈련" : "\(sessions.count)회 훈련")
                    .font(.appCaption)
                    .foregroundStyle(Color.appTextSecondary)
            }

            Spacer()

            if let best = bestSession {
                GradeBadge(grade: best.grade, size: 32)
            } else {
                Text("—")
                    .font(.appBody)
                    .foregroundStyle(Color.appTextDisabled)
            }
        }
        .padding(DS.cardPadding)
        .cardStyle()
        .opacity(sessions.isEmpty ? 0.6 : 1)
    }
}

#Preview {
    NavigationStack {
        RecordsView()
            .environment(AppState())
            .modelContainer(for: [GameSession.self, UserSettings.self], inMemory: true)
    }
}
