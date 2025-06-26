//
//   PieChartView.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//
import SwiftUI
import Charts

struct PieChartView: View {
    var records: [ExpenseRecord]

    var categorySums: [String: Double] {
        Dictionary(grouping: records, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("📊 分類支出圖表")
                .font(.headline)
                .padding(.bottom, 10)

            Chart {
                ForEach(categorySums.sorted(by: { $0.value > $1.value }), id: \.key) { category, total in
                    SectorMark(
                        angle: .value("支出", total),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("類別", category))
                    .annotation(position: .overlay) {
                        Text(category)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 250)
        }
    }
}

