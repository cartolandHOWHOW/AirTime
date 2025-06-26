//
//  ContentView.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//

import SwiftUI





struct MenuView: View {
    let backgroundImages = ["ForMenu", "ForMenu02","ForMenu03","ForMenu04"]
    @State private var currentImageIndex = 0
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                // 背景圖
                Image(backgroundImages[currentImageIndex])
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .animation(.easeIn(duration: 1.0), value: currentImageIndex)

                // 把 Air Time 移到螢幕頂端
                VStack {
                    ZStack {
                        Color.black.opacity(0.2).blur(radius: 10)
                        Text("Air Time")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .frame(height: 60)
                    .padding(.top, 40)
                    Spacer()
                }

                // 主選單按鈕區
                VStack(spacing: 30) {
                    Spacer()

                    NavigationLink(destination: GameSelectionView()) {
                        Text("開始探索")
                    }
                    .buttonStyle(MainMenuButtonStyle())

                    Button("說明書") { }
                        .buttonStyle(MainMenuButtonStyle())

                    Button("設定") { }
                        .buttonStyle(MainMenuButtonStyle())

                    Spacer()
                }
                .padding()
            }
            .onReceive(timer) { _ in
                currentImageIndex = (currentImageIndex + 1) % backgroundImages.count
            }
        }
    }
}

struct MainMenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200, height: 45)
            .background(Color.brown)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(radius: configuration.isPressed ? 2 : 6)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    MenuView()
}
