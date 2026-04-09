import SwiftUI

struct GameImageView: View {
    let imageName: String
    let fallbackSymbol: String
    var fallbackFontSize: CGFloat = 20
    var accessibilityLabel: String? = nil

    var body: some View {
        if let uiImage = UIImage(named: imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .accessibilityLabel(Text(accessibilityLabel ?? ""))
                .accessibilityHidden(accessibilityLabel == nil)
        } else {
            Color.appPrimaryTint
                .overlay(
                    Image(systemName: fallbackSymbol)
                        .font(.system(size: fallbackFontSize))
                        .foregroundStyle(Color.appPrimary)
                        .accessibilityHidden(true)
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(accessibilityLabel ?? ""))
                .accessibilityHidden(accessibilityLabel == nil)
        }
    }
}
