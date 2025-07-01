//
//  PackingListView.swift
//  AirTime
//
//  Created by max on 2025/6/30.
//
import SwiftUI

struct PackingItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var isChecked: Bool
}

struct PackingCategory: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    var items: [PackingItem]
}

struct PackingListView: View {
    @State private var categories: [PackingCategory] = []
    private let storageKey = "packing_list"

    var body: some View {
        List {
            ForEach($categories) { $category in
                Section(header: Text(category.title).font(.headline)) {
                    ForEach($category.items) { $item in
                        Toggle(isOn: $item.isChecked) {
                            Text(item.name)
                        }
                    }
                }
            }
        }
        .navigationTitle("旅行打包清單")
        .onAppear {
            loadData()
        }
        .onChange(of: categories) { _ in
            saveData()
        }
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([PackingCategory].self, from: data) {
            categories = decoded
        } else {
            // 第一次使用時載入預設資料
            categories = defaultCategories
        }
    }

    func saveData() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    var defaultCategories: [PackingCategory] {
        [
            PackingCategory(title: "證件與貴重物品", items: [
                .init(name: "護照/身分證（效期6個月）", isChecked: false),
                .init(name: "簽證文件（如需要）", isChecked: false),
                .init(name: "機票資訊（電子+紙本）", isChecked: false),
                .init(name: "信用卡/金融卡", isChecked: false),
                .init(name: "現金/當地貨幣", isChecked: false),
                .init(name: "旅遊保險文件", isChecked: false),
                .init(name: "駕照", isChecked: false),
                .init(name: "疫苗接種證明", isChecked: false),
                .init(name: "緊急聯絡人資訊", isChecked: false),
            ]),
            PackingCategory(title: "3C 電子產品", items: [
                .init(name: "智慧型手機 + 充電器", isChecked: false),
                .init(name: "行動電源（10000mAh）", isChecked: false),
                .init(name: "相機 / GoPro", isChecked: false),
                .init(name: "轉接插頭（萬用型）", isChecked: false),
                .init(name: "耳機 / 耳塞", isChecked: false),
                .init(name: "備用記憶卡", isChecked: false),
                .init(name: "eSIM 或 SIM 卡", isChecked: false),
                .init(name: "穩定器 / 閱讀器", isChecked: false),
            ]),
            PackingCategory(title: "個人護理用品", items: [
                .init(name: "牙刷牙膏（旅行組）", isChecked: false),
                .init(name: "洗髮/沐浴用品（旅行組）", isChecked: false),
                .init(name: "保養品/化妝品（旅行組）", isChecked: false),
                .init(name: "防曬乳", isChecked: false),
                .init(name: "乾洗手 / 濕紙巾", isChecked: false),
                .init(name: "個人藥品 / 急救包", isChecked: false),
                .init(name: "隱形眼鏡與藥水", isChecked: false),
            ]),
            PackingCategory(title: "舒適旅行配件", items: [
                .init(name: "頸枕 / 眼罩 / 耳塞", isChecked: false),
                .init(name: "室內拖鞋 / 旅行雨衣", isChecked: false),
                .init(name: "摺疊傘", isChecked: false),
            ]),
            PackingCategory(title: "其他實用物品", items: [
                .init(name: "水壺", isChecked: false),
                .init(name: "日用背包", isChecked: false),
                .init(name: "收納袋", isChecked: false),
                .init(name: "筆記本與筆", isChecked: false),
                .init(name: "太陽眼鏡", isChecked: false),
                .init(name: "暈車藥 / 洗衣精", isChecked: false),
                .init(name: "小型縫紉包", isChecked: false),
                .init(name: "換洗衣物", isChecked: false),
                .init(name: "備用眼鏡", isChecked: false),
                .init(name: "泳衣", isChecked: false),
            ])
        ]
    }
}

