import SwiftUI

extension Color {
    // ── 배경 / 서피스 / 경계선 ──
    static let appBackground   = Color(hex: "#FAFAFA")
    static let appSurface      = Color(hex: "#FFFFFF")
    static let appBorder       = Color(hex: "#F0F0F0")

    // ── Primary ──
    static let appPrimary      = Color(hex: "#2563EB")
    static let appPrimaryTint  = Color(hex: "#EFF6FF")

    // ── 텍스트 ──
    static let appTextPrimary   = Color(hex: "#111111")
    static let appTextSecondary = Color(hex: "#6B7280")
    static let appTextDisabled  = Color(hex: "#D1D5DB")

    // ── 카테고리 (등급·fallback 아이콘 한정 사용) ──
    static func categoryColor(_ category: GameCategory) -> Color {
        switch category {
        case .reaction: Color(hex: "#7C3AED")
        case .memory:   Color(hex: "#16A34A")
        case .judgment: Color(hex: "#F97316")
        }
    }

    // ── 등급 ──
    static func gradeColor(_ grade: String) -> Color {
        switch grade {
        case "A":    Color(hex: "#16A34A")
        case "B":    Color(hex: "#2563EB")
        case "C":    Color(hex: "#D97706")
        default:     Color(hex: "#DC2626")
        }
    }

    static func gradeTintColor(_ grade: String) -> Color {
        switch grade {
        case "A":    Color(hex: "#DCFCE7")
        case "B":    Color(hex: "#DBEAFE")
        case "C":    Color(hex: "#FEF3C7")
        default:     Color(hex: "#FEE2E2")
        }
    }

    // ── HEX 헬퍼 ──
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
