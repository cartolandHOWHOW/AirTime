//
//  ForeignWeatherView.swift
//  AirTime
//
//  Created by max on 2025/7/1.
//

import SwiftUI

struct OpenWeatherResponse: Codable {
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    struct Main: Codable {
        let temp: Double
        let humidity: Int
    }
    struct Wind: Codable {
        let speed: Double
    }

    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

struct ForeignWeatherView: View {
    @State private var selectedCity = "Tokyo"
    @State private var weather: OpenWeatherResponse?
    @State private var errorMessage = ""

    let cities = ["Tokyo", "New York", "London", "Paris", "Sydney", "Bangkok","Ho Chi Minh City"]
    let apiKey = "82eb291386b31d7ef119026ebe3ea70d"

    var body: some View {
        VStack(spacing: 20) {
            Text("🌍 國外天氣預報")
                .font(.largeTitle)

            Picker("選擇城市", selection: $selectedCity) {
                ForEach(cities, id: \.self) { city in
                    Text(city)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .pickerStyle(MenuPickerStyle())
            .padding()

            if let weather = weather {
                VStack(spacing: 10) {
                    Text("城市：\(weather.name)")
                    Text("天氣：\(weather.weather.first?.description ?? "N/A")")
                    Text("溫度：\(String(format: "%.1f", weather.main.temp))℃")
                    Text("濕度：\(weather.main.humidity)%")
                    Text("風速：\(weather.wind.speed) m/s")
                }
                .padding()
            } else if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            } else {
                Text("載入中...").foregroundColor(.gray)
            }

            Spacer()
        }
        .onAppear {
            fetchWeather(for: selectedCity)
        }
        .onChange(of: selectedCity) { newValue in
            fetchWeather(for: newValue)
        }
        .padding()
    }

    func fetchWeather(for city: String) {
        weather = nil
        errorMessage = ""

        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric&lang=zh_tw"

        guard let url = URL(string: urlString) else {
            errorMessage = "無效的網址"
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "無資料回傳"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.weather = decoded
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "資料解析失敗"
                }
            }
        }.resume()
    }
}
