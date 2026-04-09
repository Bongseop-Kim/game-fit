import SwiftUI

/// 가로 3칸 메트릭 스트립. HomeView·RecordsView·ResultView에서 공용 사용.
struct MetricStrip: View {
    let items: [MetricItem]

    struct MetricItem {
        let label: String
        let value: String
        var valueColor: Color = Color.appTextPrimary
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                VStack(spacing: 3) {
                    Text(item.value)
                        .font(.appHeadline)
                        .foregroundStyle(item.valueColor)
                    Text(item.label)
                        .font(.appCaption)
                        .foregroundStyle(Color.appTextSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)

                if index < items.count - 1 {
                    Divider()
                        .frame(height: 32)
                }
            }
        }
        .cardStyle()
    }
}

#Preview {
    MetricStrip(items: [
        .init(label: "총 훈련", value: "42"),
        .init(label: "연속",   value: "7일"),
        .init(label: "종합등급", value: "B+", valueColor: Color.appPrimary),
    ])
    .padding()
    .background(Color.appBackground)
}
