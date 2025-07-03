////
////  BrickBreakerView.swift
////  AirTime
////
////  Created by max on 2025/6/26.
////
//import SwiftUI
//
//struct BrickBreakerView: View {
//    @State private var ballPosition = CGPoint(x: 200, y: 500)
//    @State private var ballVelocity = CGSize(width: 4, height: -4)
//    @State private var paddleX: CGFloat = 200
//    @State private var bricks: [CGRect] = []
//
//    let paddleWidth: CGFloat = 100
//    let ballSize: CGFloat = 20
//    let screenWidth: CGFloat = 400
//    let screenHeight: CGFloat = 700
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                Color.black.ignoresSafeArea()
//
//                // 磚塊
//                ForEach(0..<bricks.count, id: \.self) { index in
//                    Rectangle()
//                        .fill(Color.orange)
//                        .frame(width: bricks[index].width, height: bricks[index].height)
//                        .position(x: bricks[index].midX, y: bricks[index].midY)
//                }
//
//                // 球
//                Circle()
//                    .fill(Color.white)
//                    .frame(width: ballSize, height: ballSize)
//                    .position(ballPosition)
//
//                // 板子
//                Rectangle()
//                    .fill(Color.blue)
//                    .frame(width: paddleWidth, height: 20)
//                    .position(x: paddleX, y: geo.size.height - 50)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                paddleX = value.location.x
//                            }
//                    )
//
//                // 如果球掉出邊界就顯示 Game Over
//                if ballPosition.y > geo.size.height {
//                    VStack {
//                        Text("Game Over")
//                            .foregroundColor(.white)
//                            .font(.largeTitle)
//                            .padding()
//                        Button("再玩一次") {
//                            resetGame(in: geo.size)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .foregroundColor(.black)
//                        .clipShape(Capsule())
//                    }
//                }
//            }
//            .onAppear {
//                setupBricks()
//                resetGame(in: geo.size)
//            }
//            .onReceive(Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()) { _ in
//                updateBall(in: geo.size)
//            }
//        }
//    }
//
//    // 初始化磚塊排列
//    func setupBricks() {
//        bricks = []
//        let cols = 5
//        let rows = 3
//        let brickWidth: CGFloat = 70
//        let brickHeight: CGFloat = 25
//        let spacing: CGFloat = 10
//
//        for row in 0..<rows {
//            for col in 0..<cols {
//                let x = CGFloat(col) * (brickWidth + spacing) + 40
//                let y = CGFloat(row) * (brickHeight + spacing) + 80
//                bricks.append(CGRect(x: x, y: y, width: brickWidth, height: brickHeight))
//            }
//        }
//    }
//
//    func resetGame(in size: CGSize) {
//        ballPosition = CGPoint(x: size.width / 2, y: size.height / 2)
//        ballVelocity = CGSize(width: 4, height: -4)
//        paddleX = size.width / 2
//        setupBricks()
//    }
//
//    func updateBall(in size: CGSize) {
//        guard ballPosition.y <= size.height else { return } // 避免球已經出界後還繼續跑
//
//        // 移動球
//        ballPosition.x += ballVelocity.width
//        ballPosition.y += ballVelocity.height
//
//        // 碰牆反彈
//        if ballPosition.x <= 0 || ballPosition.x >= size.width {
//            ballVelocity.width *= -1
//        }
//
//        if ballPosition.y <= 0 {
//            ballVelocity.height *= -1
//        }
//
//        // 碰到板子
//        let paddleFrame = CGRect(x: paddleX - paddleWidth / 2, y: size.height - 60, width: paddleWidth, height: 20)
//        if paddleFrame.contains(ballPosition) {
//            ballVelocity.height *= -1
//        }
//
//        // 碰到磚塊
//        for i in 0..<bricks.count {
//            if bricks[i].contains(ballPosition) {
//                ballVelocity.height *= -1
//                bricks.remove(at: i)
//                break
//            }
//        }
//    }
//}
//
