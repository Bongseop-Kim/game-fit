import SwiftUI

struct MetricCard: View {
    let title: String
    let value: String
    var icon: String? = nil

    var body: some View {
        VStack(spacing: 6) {
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                    .font(.appCaption)
            }
            Text(value)
                .font(.appHeadline)
                .foregroundStyle(.primary)
            Text(title)
                .font(.appCaption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    HStack {
        MetricCard(title: "총 훈련", value: "42회", icon: "flame.fill")
        MetricCard(title: "연속일",  value: "7일",  icon: "calendar")
        MetricCard(title: "종합등급", value: "A",   icon: "star.fill")
    }
    .padding()
}
