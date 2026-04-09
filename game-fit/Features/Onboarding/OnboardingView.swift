import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Bindable var settings: UserSettings
    @State private var currentPage: Int = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "onboarding_1",
            fallbackSymbol: "brain.head.profile",
            title: "AI 면접, 감각으로\n준비하세요",
            description: "9가지 미니게임으로 반응속도, 기억력, 판단력을 훈련할 수 있어요."
        ),
        OnboardingPage(
            imageName: "onboarding_2",
            fallbackSymbol: "square.grid.3x3.fill",
            title: "3가지 역량,\n9가지 게임",
            description: "반응속도 · 기억력 · 판단력 카테고리별 게임으로 균형 있게 훈련해요."
        ),
        OnboardingPage(
            imageName: "onboarding_3",
            fallbackSymbol: "chart.line.uptrend.xyaxis",
            title: "매일 꾸준히,\n성장을 확인하세요",
            description: "훈련 기록과 성장 추이를 한눈에 확인하고 약점을 집중 보완해요."
        ),
    ]

    var body: some View {
        VStack(spacing: 0) {
            progressBar
                .padding(.horizontal)
                .padding(.top, 16)

            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            buttonArea
                .padding(.horizontal)
                .padding(.bottom, 40)
        }
        .background(Color.appSurface)
    }

    private var progressBar: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.appBorder).frame(height: 3)
                Capsule()
                    .fill(Color.appPrimary)
                    .frame(width: proxy.size.width * CGFloat(currentPage + 1) / CGFloat(pages.count), height: 3)
                    .animation(.easeInOut(duration: 0.25), value: currentPage)
            }
        }
        .frame(height: 3)
    }

    @ViewBuilder
    private var buttonArea: some View {
        if currentPage < pages.count - 1 {
            PrimaryButton(title: "다음") {
                withAnimation { currentPage += 1 }
            }
        } else {
            PrimaryButton(title: "시작하기") {
                settings.isOnboardingComplete = true
            }
        }
    }
}

private struct OnboardingPage {
    let imageName: String
    let fallbackSymbol: String
    let title: String
    let description: String
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GameImageView(
                imageName: page.imageName,
                fallbackSymbol: page.fallbackSymbol,
                fallbackFontSize: 64
            )
            .frame(maxWidth: .infinity)
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            .padding(.top, 24)

            VStack(alignment: .leading, spacing: 12) {
                Text(page.title)
                    .font(.appTitle)
                    .foregroundStyle(Color.appTextPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(page.description)
                    .font(.appBody)
                    .foregroundStyle(Color.appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal)
            .padding(.top, 24)

            Spacer()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserSettings.self, configurations: config)
    let settings = UserSettings()
    container.mainContext.insert(settings)
    return OnboardingView(settings: settings)
}
