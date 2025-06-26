//
//  ChatMessage.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//
import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
