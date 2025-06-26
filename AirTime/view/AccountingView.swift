//
//  AccountingView.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//
import SwiftUI

struct AccountingView: View {
    @State private var nameText = ""
    @State private var selectedCategory = "餐費"
    @State private var amountText = ""
    @State private var records: [ExpenseRecord] = [] {
        didSet {
            saveRecords() // 每次變動就儲存
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    let recordsKey = "expenseRecords"

    func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: recordsKey)
        }
    }

    func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: recordsKey),
           let decoded = try? JSONDecoder().decode([ExpenseRecord].self, from: data) {
            records = decoded
        }
    }
    
    let categories = ["餐費", "交通費", "小費", "門票","其他"]

    var body: some View {
        VStack(spacing: 20) {
            Text("旅遊記帳本")
                .font(.largeTitle)
                .bold()
                .onAppear {
                    loadRecords()
                }
            Picker("選擇類別", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                }
            }
            .pickerStyle(.segmented)

            HStack {
                
                TextField("輸入名稱（可空白）", text: $nameText)
                    .textFieldStyle(.roundedBorder)
                
                TextField("輸入金額", text: $amountText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)

                
                
                Button("新增") {
                    if let amount = Double(amountText) {
                        let newRecord = ExpenseRecord(
                            category: selectedCategory,
                            amount: amount,
                            date: Date(),
                            name: nameText.isEmpty ? nil : nameText
                        )
                        records.append(newRecord)
                        amountText = ""
                        nameText = ""
                    }
                }
                .buttonStyle(.borderedProminent)
            }

            Divider()

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    ForEach(records) { record in
                        VStack(spacing: 5) {
                            Text(record.category)
                                .font(.headline)

                            if let name = record.name, !name.isEmpty {
                                Text(name)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }

                            Text("$\(Int(record.amount))")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.green)

                            Text(dateFormatter.string(from: record.date))
                                .font(.caption)
                                .foregroundColor(.gray)

                            Button(role: .destructive) {
                                if let index = records.firstIndex(where: { $0.id == record.id }) {
                                    records.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .padding(.top, 5)
                        }
                        
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(12)
                        
                    }
                }
                .padding()
            }

            Spacer()
        }
        .padding()
    }
}

