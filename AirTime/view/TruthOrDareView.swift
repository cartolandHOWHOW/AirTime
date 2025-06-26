//
//  TruthOrDareView.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//

import SwiftUI

struct TruthOrDareView: View {
    @State private var angle: Double = 0
    @State private var resultText: String? = nil
    @State private var isSpinning = false

    let options = ["真心話", "大冒險"]

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("真心話大冒險")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.orange)

            ZStack {
                Circle()
                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 5)
                    .frame(width: 200, height: 200)

                Image(systemName: "airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(angle))
                    .animation(.easeOut(duration: 2), value: angle)
                    .foregroundColor(.blue)
            }

            Button(action: {
                guard !isSpinning else { return } // 防止重複點擊
                isSpinning = true
                resultText = nil

                // 旋轉3~6圈後停下
                let randomRounds = Double.random(in: 3...6)
                let newAngle = angle + randomRounds * 360
                angle = newAngle

                // 延遲顯示結果
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    resultText = options.randomElement()
                    isSpinning = false
                }
            }) {
                Text("開始旋轉")
                    .bold()
                    .frame(width: 180, height: 50)
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 5)
            }

            if let result = resultText {
                Text("🎉 請進行「\(result)」！")
                    .font(.title2)
                    .foregroundColor(.purple)
                    .padding()
            }

            Spacer()
        }
        .padding()
    }
}
