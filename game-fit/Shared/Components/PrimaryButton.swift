import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButtonLabel)
                .frame(maxWidth: .infinity)
                .frame(height: DS.buttonHeight)
                .background(isDisabled ? Color.appPrimaryTint : Color.appPrimary)
                .foregroundStyle(isDisabled ? Color.appPrimary : .white)
                .clipShape(RoundedRectangle(cornerRadius: DS.buttonRadius))
        }
        .disabled(isDisabled)
    }
}

struct PrimaryButtonLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.appButtonLabel)
            .frame(maxWidth: .infinity)
            .frame(height: DS.buttonHeight)
            .background(Color.appPrimary)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: DS.buttonRadius))
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButtonLabel)
                .frame(maxWidth: .infinity)
                .frame(height: DS.buttonHeight)
                .background(Color.appSurface)
                .foregroundStyle(Color.appTextPrimary)
                .clipShape(RoundedRectangle(cornerRadius: DS.buttonRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: DS.buttonRadius)
                        .stroke(Color.appBorder, lineWidth: 1)
                )
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        PrimaryButton(title: "훈련 시작") {}
        PrimaryButton(title: "비활성", isDisabled: true) {}
        SecondaryButton(title: "다음 난이도") {}
    }
    .padding()
    .background(Color.appBackground)
}
