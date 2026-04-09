import SwiftUI

struct GameCard: View {
    let game: GameMeta
    var compact: Bool = false
    var bestGrade: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            imageArea
            textArea
        }
        .cardStyle()
    }

    private var imageArea: some View {
        GameImageView(
            imageName: "game_\(game.id)",
            fallbackSymbol: game.sfSymbol,
            fallbackFontSize: compact ? 16 : 20
        )
        .frame(height: compact ? 48 : 72)
        .clipped()
    }

    private var textArea: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .center) {
                Text(game.name)
                    .font(compact ? .appMicro.weight(.semibold) : .appCardTitle)
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                Spacer()
                gradeIndicator
            }
            if !compact {
                Text(game.description)
                    .font(.appCaption)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(1)
            }
        }
        .padding(compact ? 8 : 10)
    }

    @ViewBuilder
    private var gradeIndicator: some View {
        if let grade = bestGrade {
            Text(grade)
                .font(.appMicro)
                .foregroundStyle(Color.gradeColor(grade))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.gradeTintColor(grade))
                .clipShape(Capsule())
        } else {
            Text("미훈련")
                .font(.appSectionLabel)
                .foregroundStyle(Color.appTextDisabled)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        HStack(spacing: 10) {
            GameCard(game: GameMeta.all[0], bestGrade: "A")
            GameCard(game: GameMeta.all[1])
        }
        HStack(spacing: 8) {
            GameCard(game: GameMeta.all[4], compact: true, bestGrade: "B")
            GameCard(game: GameMeta.all[5], compact: true)
            GameCard(game: GameMeta.all[6], compact: true)
        }
    }
    .padding()
    .background(Color.appBackground)
}
