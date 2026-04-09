import SwiftUI
import Charts

struct LineChart: View {
    let dataPoints: [(date: Date, accuracy: Double)]  // accuracy: 0.0~1.0

    var body: some View {
        Chart {
            ForEach(dataPoints, id: \.date) { point in
                LineMark(
                    x: .value("날짜", point.date, unit: .day),
                    y: .value("정확도", point.accuracy * 100)
                )
                .foregroundStyle(Color.blue)
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("날짜", point.date, unit: .day),
                    y: .value("정확도", point.accuracy * 100)
                )
                .foregroundStyle(Color.blue)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisValueLabel(format: .dateTime.month().day())
                AxisGridLine()
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) { value in
                AxisValueLabel { Text("\(Int(value.as(Double.self) ?? 0))%") }
                AxisGridLine()
            }
        }
        .chartYScale(domain: 0...100)
        .frame(height: 160)
    }
}

#Preview {
    let now = Date.now
    let calendar = Calendar.current
    let data: [(date: Date, accuracy: Double)] = (0..<7).map { daysAgo in
        let date = calendar.date(byAdding: .day, value: -(6 - daysAgo), to: now)!
        return (date: date, accuracy: Double.random(in: 0.6...1.0))
    }
    LineChart(dataPoints: data)
        .padding()
}
