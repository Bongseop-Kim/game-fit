import SwiftUI
import Charts

struct BarChart: View {
    let values: [Double]           // 라운드별 반응속도 (초)
    let incorrectIndices: Set<Int> // 오답 라운드 인덱스

    var body: some View {
        Chart {
            ForEach(Array(values.enumerated()), id: \.offset) { index, value in
                BarMark(
                    x: .value("라운드", index + 1),
                    y: .value("반응속도(s)", value)
                )
                .foregroundStyle(incorrectIndices.contains(index) ? Color.red.opacity(0.8) : Color.blue.opacity(0.7))
                .cornerRadius(4)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisValueLabel { Text("\(value.as(Int.self) ?? 0)") }
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) { value in
                AxisValueLabel { Text(String(format: "%.1fs", value.as(Double.self) ?? 0)) }
                AxisGridLine()
            }
        }
        .frame(height: 160)
    }
}

#Preview {
    BarChart(
        values: [1.2, 0.9, 1.8, 0.7, 2.1, 1.0, 0.8, 1.5, 0.6, 1.3],
        incorrectIndices: [2, 4]
    )
    .padding()
}
