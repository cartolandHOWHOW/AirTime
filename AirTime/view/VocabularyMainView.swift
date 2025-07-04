//
//  VocabularyMainView.swift
//  AirTime
//
//  Created by max on 2025/7/4.
//
import SwiftUI

struct VocabularyMainView: View {
    @State private var collectedWordIDs: Set<String> = []

    var body: some View {
        TabView {
            // 第1個 Tab：單字訓練畫面
            VocabularyView()
                .tabItem {
                    Label("單字列表", systemImage: "book")
                }

            // 第2個 Tab：收藏清單畫面 ← 改成不傳參數
            CollectedView()
                .tabItem {
                    Label("收藏清單", systemImage: "star.fill")
                }
        }
    }
}
