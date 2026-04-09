import SwiftUI

struct DifficultyPicker: View {
    @Binding var selected: Difficulty

    var body: some View {
        HStack(spacing: 2) {
            ForEach(Difficulty.allCases, id: \.self) { diff in
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) { selected = diff }
                } label: {
                    Text(diff.displayName)
                        .font(.appLabel.weight(selected == diff ? .semibold : .regular))
                        .foregroundStyle(selected == diff ? Color.appTextPrimary : Color.appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            Group {
                                if selected == diff {
                                    Color.appSurface
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    @Previewable @State var selected = Difficulty.normal
    DifficultyPicker(selected: $selected)
        .padding()
        .background(Color.appBackground)
}
