import SwiftUI

struct GameImageView: View {
    let imageName: String
    let fallbackSymbol: String
    var fallbackFontSize: CGFloat = 20

    var body: some View {
        if let uiImage = UIImage(named: imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Color.appPrimaryTint
                .overlay(
                    Image(systemName: fallbackSymbol)
                        .font(.system(size: fallbackFontSize))
                        .foregroundStyle(Color.appPrimary)
                )
        }
    }
}
