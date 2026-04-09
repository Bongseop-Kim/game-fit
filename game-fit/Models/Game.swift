import Foundation

enum GameCategory: String, CaseIterable {
    case reaction
    case memory
    case judgment

    var displayName: String {
        switch self {
        case .reaction: "반응속도"
        case .memory:   "기억력"
        case .judgment: "판단력"
        }
    }
}

struct GameMeta: Identifiable {
    let id: String
    let name: String
    let description: String
    let category: GameCategory
    let sfSymbol: String

    static let all: [GameMeta] = [
        GameMeta(id: "rock_paper_scissors", name: "가위바위보",        description: "빠른 판단",  category: .reaction, sfSymbol: "hand.raised.fingers.spread"),
        GameMeta(id: "number_tap",          name: "숫자 누르기",       description: "순차 터치",  category: .reaction, sfSymbol: "textformat.123"),
        GameMeta(id: "shape_sequence",      name: "도형 순서 기억하기", description: "순차 기억",  category: .memory,   sfSymbol: "square.stack.3d.up"),
        GameMeta(id: "shape_rotation",      name: "도형 회전하기",      description: "공간 지각",  category: .memory,   sfSymbol: "arrow.triangle.2.circlepath"),
        GameMeta(id: "count_compare",       name: "개수 비교하기",      description: "수량 판단",  category: .judgment, sfSymbol: "number.circle"),
        GameMeta(id: "magic_potion",        name: "마법약 만들기",      description: "조건 조합",  category: .judgment, sfSymbol: "flask"),
        GameMeta(id: "night_song",          name: "야곡 정하기",        description: "조건 선택",  category: .judgment, sfSymbol: "music.note"),
        GameMeta(id: "path_making",         name: "길 만들기",          description: "경로 연결",  category: .judgment, sfSymbol: "point.3.connected.trianglepath.dotted"),
        GameMeta(id: "cat_chase",           name: "고양이 술래잡기",    description: "추적 판단",  category: .judgment, sfSymbol: "pawprint"),
    ]

    static func games(for category: GameCategory) -> [GameMeta] {
        all.filter { $0.category == category }
    }

    static func find(id: String) -> GameMeta? {
        all.first { $0.id == id }
    }
}

enum Difficulty: String, CaseIterable {
    case easy
    case normal
    case hard

    var displayName: String {
        switch self {
        case .easy:   "쉬움"
        case .normal: "보통"
        case .hard:   "어려움"
        }
    }

    var levelDescription: String {
        switch self {
        case .easy:   "반응 시간이 넉넉해요"
        case .normal: "적당한 속도로 훈련해요"
        case .hard:   "빠른 판단력이 필요해요"
        }
    }

    var next: Difficulty? {
        switch self {
        case .easy:   .normal
        case .normal: .hard
        case .hard:   nil
        }
    }
}
