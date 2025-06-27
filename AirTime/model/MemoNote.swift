//
//  MemoNote.swift
//  AirTime
//
//  Created by max on 2025/6/27.
//
import Foundation

struct MemoNote: Identifiable, Codable {
    let id = UUID()
    let content: String
    let date: Date
}
