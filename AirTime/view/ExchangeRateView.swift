//
//  ExchangeRateView.swift
//  AirTime
//
//  Created by max on 2025/7/2.
//

import SwiftUI

struct ExchangeRateView: View {
    @State private var fromCurrency = "TWD"
    @State private var toCurrency = "USD"
    @State private var rate: Double?
    @State private var errorMessage = ""

    let currencies = ["TWD", "USD", "JPY", "EUR", "KRW", "THB", "AUD", "GBP"]

    var body: some View {
        VStack(spacing: 20) {
            Text("💱 匯率查詢")
                .font(.largeTitle)

            HStack {
                Picker("從", selection: $fromCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Text("➡️")

                Picker("到", selection: $toCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            if let rate = rate {
                Text("1 \(fromCurrency) ≈ \(String(format: "%.4f", rate)) \(toCurrency)")
                    .font(.title2)
            } else if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            } else {
                Text("查詢中...").foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            fetchRate()
        }
        .onChange(of: fromCurrency) { _ in fetchRate() }
        .onChange(of: toCurrency) { _ in fetchRate() }
    }

    func fetchRate() {
        rate = nil
        errorMessage = ""

        let urlString = "https://api.exchangerate.host/convert?from=\(fromCurrency)&to=\(toCurrency)"

        guard let url = URL(string: urlString) else {
            errorMessage = "無效的網址"
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let rate = result["result"] as? Double {
                    DispatchQueue.main.async {
                        self.rate = rate
                    }
                } else {
                    DispatchQueue.main.async {
                        errorMessage = "解析資料失敗"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "載入失敗"
                }
            }
        }.resume()
    }
}

