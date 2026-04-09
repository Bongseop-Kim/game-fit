import Foundation

extension GameMeta: Hashable {
    static func == (lhs: GameMeta, rhs: GameMeta) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
