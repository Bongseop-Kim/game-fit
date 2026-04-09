import SwiftUI

struct CountdownOverlay: View {
    let onComplete: () -> Void

    @State private var count: Int = 3
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 8) {
                Text("\(count)")
                    .font(.appCountdown)
                    .foregroundStyle(.white)
                    .scaleEffect(scale)
                    .opacity(opacity)

                Text("준비하세요")
                    .font(.appBody)
                    .foregroundStyle(.white.opacity(0.7))
                    .opacity(opacity)
            }
        }
        .onAppear { runCountdown() }
    }

    private func runCountdown() {
        Task {
            for i in stride(from: 3, through: 1, by: -1) {
                count = i
                withAnimation(.spring(duration: 0.3)) {
                    scale = 1.0
                    opacity = 1.0
                }
                try? await Task.sleep(for: .milliseconds(700))
                withAnimation(.easeOut(duration: 0.2)) {
                    scale = 1.8
                    opacity = 0
                }
                try? await Task.sleep(for: .milliseconds(300))
                scale = 0.5
            }
            onComplete()
        }
    }
}

#Preview {
    CountdownOverlay { print("완료") }
}
