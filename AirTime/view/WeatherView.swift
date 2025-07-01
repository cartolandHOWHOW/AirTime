//
//  WeatherView.swift
//  AirTime
//
//  Created by max on 2025/7/1.
//
//CWA-CA717115-1ACE-45CE-A883-39CE6576D10A
import SwiftUI

struct WeatherView: View {
    @State private var selectedCity = "臺北市"
    @State private var weatherInfo = "讀取中..."

    let cities = ["臺北市", "新北市", "桃園市", "臺中市", "臺南市", "高雄市"]

    var body: some View {
        VStack(spacing: 20) {
            Text("🌦️ 天氣預報")
                .font(.largeTitle)

            Picker("選擇城市", selection: $selectedCity) {
                ForEach(cities, id: \.self) { city in
                    Text(city)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Text("\(selectedCity) 天氣：")
                .font(.headline)
            Text(weatherInfo)
                .padding()

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
        weatherInfo = "讀取中..."

        let apiKey = "CWA-CA717115-1ACE-45CE-A883-39CE6576D10A"
        let urlString = "https://opendata.cwa.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=\(apiKey)&locationName=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        guard let url = URL(string: urlString) else {
            weatherInfo = "無效的網址"
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let records = result["records"] as? [String: Any],
                   let locations = records["location"] as? [[String: Any]],
                   let location = locations.first,
                   let weatherElements = location["weatherElement"] as? [[String: Any]],
                   let wx = weatherElements.first,
                   let timeArray = wx["time"] as? [[String: Any]],
                   let first = timeArray.first,
                   let parameter = first["parameter"] as? [String: Any],
                   let weather = parameter["parameterName"] as? String {
                    DispatchQueue.main.async {
                        self.weatherInfo = weather
                    }
                } else {
                    DispatchQueue.main.async {
                        self.weatherInfo = "資料解析失敗"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.weatherInfo = "網路錯誤"
                }
            }
        }.resume()
    }
}
