//
//  GameSelectionView.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//
import SwiftUI

struct GameSelectionView: View {
    
    
    
    
    
    
    
    
    
    
    let games: [GameItem] = [
        
        GameItem(
            title: "敲磚遊戲",
            imageName: "circle.grid.hex", // 或用 "gamecontroller"
            destinationView: AnyView(BrickBreakerView())
        ),
        
        GameItem(
            title: "查看目前位置",
            imageName: "map",
            destinationView: AnyView(MapFeatureView())
        ),
        
        
        GameItem(
            title: "真心話大冒險",
            imageName: "airplane",
            destinationView: AnyView(TruthOrDareView())
        ),
        
        GameItem(
            title: "啟動羅盤",
            imageName: "location.north.line", // 可以換其他 compass 圖示
            destinationView: AnyView(CompassView())
        ),
        
        GameItem(
            title: "記帳本",
            imageName: "book.fill",
            destinationView: AnyView(AccountingView())
        ),
        
        GameItem(
            title: "聊天木頭人",
            imageName: "person.crop.square.filled.and.at.rectangle",
            destinationView: AnyView(WoodenManView())
        )
        
        // 未來新增更多只要加在這裡就行
    ]

    // Grid 設定
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(games) { game in
                    NavigationLink(destination: game.destinationView) {
                        VStack(spacing: 10) {
                            Image(systemName: game.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .foregroundColor(.blue)

                            Text(game.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: 4)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("選擇功能")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

