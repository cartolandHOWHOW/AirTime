import SwiftUI

struct VisaFreeView: View {
    struct VisaCountry: Identifiable {
        let id = UUID()
        let name: String
        let englishName: String
        let days: String
    }

    let visaFreeCountries: [VisaCountry] = [
        // 90 天免簽
        VisaCountry(name: "阿爾巴尼亞", englishName: "Albania", days: "90 天"),
        VisaCountry(name: "安道爾", englishName: "Andorra", days: "90 天"),
        VisaCountry(name: "澳大利亞", englishName: "Australia", days: "90 天"),
        VisaCountry(name: "奧地利", englishName: "Austria", days: "90 天"),
        VisaCountry(name: "比利時", englishName: "Belgium", days: "90 天"),
        VisaCountry(name: "保加利亞", englishName: "Bulgaria", days: "90 天"),
        VisaCountry(name: "加拿大", englishName: "Canada", days: "90 天"),
        VisaCountry(name: "智利", englishName: "Chile", days: "90 天"),
        VisaCountry(name: "克羅埃西亞", englishName: "Croatia", days: "90 天"),
        VisaCountry(name: "賽普勒斯", englishName: "Cyprus", days: "90 天"),
        VisaCountry(name: "捷克", englishName: "Czech Republic", days: "90 天"),
        VisaCountry(name: "丹麥", englishName: "Denmark", days: "90 天"),
        VisaCountry(name: "史瓦帝尼", englishName: "Eswatini", days: "90 天"),
        VisaCountry(name: "愛沙尼亞", englishName: "Estonia", days: "90 天"),
        VisaCountry(name: "芬蘭", englishName: "Finland", days: "90 天"),
        VisaCountry(name: "法國", englishName: "France", days: "90 天"),
        VisaCountry(name: "德國", englishName: "Germany", days: "90 天"),
        VisaCountry(name: "希臘", englishName: "Greece", days: "90 天"),
        VisaCountry(name: "瓜地馬拉", englishName: "Guatemala", days: "90 天"),
        VisaCountry(name: "海地", englishName: "Haiti", days: "90 天"),
        VisaCountry(name: "教廷", englishName: "Holy See", days: "90 天"),
        VisaCountry(name: "宏都拉斯", englishName: "Honduras", days: "90 天"),
        VisaCountry(name: "匈牙利", englishName: "Hungary", days: "90 天"),
        VisaCountry(name: "冰島", englishName: "Iceland", days: "90 天"),
        VisaCountry(name: "愛爾蘭", englishName: "Ireland", days: "90 天"),
        VisaCountry(name: "以色列", englishName: "Israel", days: "90 天"),
        VisaCountry(name: "義大利", englishName: "Italy", days: "90 天"),
        VisaCountry(name: "日本", englishName: "Japan", days: "90 天"),
        VisaCountry(name: "科索沃", englishName: "Kosovo", days: "90 天"),
        VisaCountry(name: "韓國", englishName: "Republic of Korea", days: "90 天"),
        VisaCountry(name: "拉脫維亞", englishName: "Latvia", days: "90 天"),
        VisaCountry(name: "列支敦斯登", englishName: "Liechtenstein", days: "90 天"),
        VisaCountry(name: "立陶宛", englishName: "Lithuania", days: "90 天"),
        VisaCountry(name: "盧森堡", englishName: "Luxembourg", days: "90 天"),
        VisaCountry(name: "馬爾他", englishName: "Malta", days: "90 天"),
        VisaCountry(name: "馬紹爾群島", englishName: "Marshall Islands", days: "90 天"),
        VisaCountry(name: "摩納哥", englishName: "Monaco", days: "90 天"),
        VisaCountry(name: "荷蘭", englishName: "Netherlands", days: "90 天"),
        VisaCountry(name: "紐西蘭", englishName: "New Zealand", days: "90 天"),
        VisaCountry(name: "尼加拉瓜", englishName: "Nicaragua", days: "90 天"),
        VisaCountry(name: "北馬其頓", englishName: "North Macedonia", days: "90 天"),
        VisaCountry(name: "挪威", englishName: "Norway", days: "90 天"),
        VisaCountry(name: "帛琉", englishName: "Palau", days: "90 天"),
        VisaCountry(name: "巴拉圭", englishName: "Paraguay", days: "90 天"),
        VisaCountry(name: "波蘭", englishName: "Poland", days: "90 天"),
        VisaCountry(name: "葡萄牙", englishName: "Portugal", days: "90 天"),
        VisaCountry(name: "羅馬尼亞", englishName: "Romania", days: "90 天"),
        VisaCountry(name: "聖馬利諾", englishName: "San Marino", days: "90 天"),
        VisaCountry(name: "斯洛伐克", englishName: "Slovakia", days: "90 天"),
        VisaCountry(name: "斯洛維尼亞", englishName: "Slovenia", days: "90 天"),
        VisaCountry(name: "西班牙", englishName: "Spain", days: "90 天"),
        VisaCountry(name: "瑞典", englishName: "Sweden", days: "90 天"),
        VisaCountry(name: "瑞士", englishName: "Switzerland", days: "90 天"),
        VisaCountry(name: "吐瓦魯", englishName: "Tuvalu", days: "90 天"),
        VisaCountry(name: "英國", englishName: "U.K.", days: "90 天"),
        VisaCountry(name: "美國", englishName: "U.S.A.", days: "90 天"),

        // 30 天免簽
        VisaCountry(name: "貝里斯", englishName: "Belize", days: "30 天"),
        VisaCountry(name: "多明尼加", englishName: "Dominican Republic", days: "30 天"),
        VisaCountry(name: "馬來西亞", englishName: "Malaysia", days: "30 天"),
        VisaCountry(name: "諾魯", englishName: "Nauru", days: "30 天"),
        VisaCountry(name: "聖克里斯多福", englishName: "St. Kitts and Nevis", days: "30 天"),
        VisaCountry(name: "聖露西亞", englishName: "Saint Lucia", days: "30 天"),
        VisaCountry(name: "聖文森國", englishName: "Saint Vincent and the Grenadines", days: "30 天"),
        VisaCountry(name: "新加坡", englishName: "Singapore", days: "30 天"),

        // 14 天試辦
        VisaCountry(name: "泰國", englishName: "Thailand", days: "14 天"),
        VisaCountry(name: "汶萊", englishName: "Brunei", days: "14 天"),
        VisaCountry(name: "菲律賓", englishName: "Philippines", days: "14 天"),
    ]

    var body: some View {
        List {
            ForEach(["90 天", "30 天", "14 天"], id: \.self) { group in
                Section(header: Text("\(group) 免簽")) {
                    ForEach(visaFreeCountries.filter { $0.days == group }) { country in
                        VStack(alignment: .leading) {
                            Text(country.name)
                                .font(.headline)
                            Text(country.englishName)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("免簽國家查詢")
    }
}
