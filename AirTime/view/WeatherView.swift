//
//  WeatherView.swift
//  AirTime
//
//  Created by max on 2025/7/3.
//

import SwiftUI

struct WeatherView: View {
    @State private var selectedScope = "國內"
    @State private var selectedCity = "臺北市"
    @State private var weatherDescription = "讀取中..."
    @State private var foreignWeather: OpenWeatherResponse?
    @State private var errorMessage = ""

    let scopes = ["國內", "國外"]
    let taiwanCities = ["臺北市", "新北市", "桃園市", "臺中市", "臺南市", "高雄市"]
    let foreignCities = ["Tokyo", "New York", "London", "Paris", "Sydney", "Bangkok","Ho Chi Minh City"]

    let cwaApiKey = "CWA-CA717115-1ACE-45CE-A883-39CE6576D10A"
    let openWeatherApiKey = "deefa83488113b5ec93be92686409814"
    
    func backgroundImageName(for city: String) -> String {
        switch city {
        case "桃園市": return "桃園市"
        case "高雄市": return "高雄市"
        case "臺北市": return "臺北市"
        case "新北市": return "新北市"
        case "臺南市": return "臺南市"
        case "臺中市": return "臺中市"
        default: return "default_background" // 其他城市或預設圖片
        }
    }

    var body: some View {
        ZStack{
            Image(backgroundImageName(for: selectedCity))
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.25) // 可依喜好調整透明度
            VStack(spacing: 20) {
                Text("☁️ 天氣預報")
                    .font(.largeTitle)

                Picker("地區", selection: $selectedScope) {
                    ForEach(scopes, id: \.self) { scope in
                        Text(scope)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                Picker("選擇城市", selection: $selectedCity) {
                    ForEach(currentCityList(), id: \.self) { city in
                        Text(city)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Divider()

                Group {
                    if selectedScope == "國內" {
                        Text("\(selectedCity) 天氣：")
                            .font(.headline)
                        Text(weatherDescription)
                            .padding()
                    } else {
                        if let weather = foreignWeather {
                            VStack(spacing: 8) {
                                Text("城市：\(weather.name)")
                                Text("天氣：\(weather.weather.first?.description ?? "N/A")")
                                Text("溫度：\(String(format: "%.1f", weather.main.temp))℃")
                                Text("濕度：\(weather.main.humidity)%")
                                Text("風速：\(weather.wind.speed) m/s")
                            }
                        } else if !errorMessage.isEmpty {
                            Text(errorMessage).foregroundColor(.red)
                        } else {
                            Text("讀取中...").foregroundColor(.gray)
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .onAppear {
                fetchWeather()
            }
            .onChange(of: selectedCity) { _ in
                fetchWeather()
            }
            .onChange(of: selectedScope) { newValue in
                selectedCity = currentCityList().first ?? ""
                fetchWeather()
            }
        }
        }
        

    // MARK: - 城市列表依 scope 切換
    func currentCityList() -> [String] {
        selectedScope == "國內" ? taiwanCities : foreignCities
    }

    // MARK: - 依 scope 抓不同來源
    func fetchWeather() {
        if selectedScope == "國內" {
            fetchDomesticWeather(for: selectedCity)
        } else {
            fetchForeignWeather(for: selectedCity)
        }
    }

    // MARK: - 台灣中央氣象局
    func fetchDomesticWeather(for city: String) {
        weatherDescription = "讀取中..."
        let urlStr = "https://opendata.cwa.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=\(cwaApiKey)&locationName=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        guard let url = URL(string: urlStr) else {
            weatherDescription = "網址錯誤"
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
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
                    self.weatherDescription = weather
                }
            } else {
                DispatchQueue.main.async {
                    self.weatherDescription = "資料解析失敗"
                }
            }
        }.resume()
    }

    // MARK: - 國外 OpenWeather
    func fetchForeignWeather(for city: String) {
        foreignWeather = nil
        errorMessage = ""
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(openWeatherApiKey)&units=metric&lang=zh_tw"

        guard let url = URL(string: urlStr) else {
            errorMessage = "網址錯誤"
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
                    self.errorMessage = "無資料"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.foreignWeather = decoded
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "資料解析失敗"
                }
            }
        }.resume()
    }
}

// MARK: - OpenWeather 回傳格式
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
