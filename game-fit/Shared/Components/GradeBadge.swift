import SwiftUI

struct GradeBadge: View {
    let grade: String
    var size: CGFloat = 80

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(Color.gradeTintColor(grade))
            Text(grade)
                .font(.system(size: size * 0.5, weight: .bold))
                .foregroundStyle(Color.gradeColor(grade))
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack(spacing: 12) {
        GradeBadge(grade: "A")
        GradeBadge(grade: "B")
        GradeBadge(grade: "C")
        GradeBadge(grade: "F")
    }
    .padding()
    .background(Color.appBackground)
}
