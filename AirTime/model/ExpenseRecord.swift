//
//  ExpenseRecord.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//
import Foundation

struct ExpenseRecord: Identifiable, Codable {
    let id = UUID()
    let category: String
    let amount: Double
    let date: Date
    let name: String? // 可以為空值
}
