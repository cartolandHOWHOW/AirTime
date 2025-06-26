//
//  GameItem.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//
import SwiftUI

struct GameItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let destinationView: AnyView
}
