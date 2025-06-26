import SwiftUI
import CoreLocation

enum Direction: CaseIterable {
    case north, east, south, west

    var label: String {
        switch self {
        case .north: return "N"
        case .east: return "E"
        case .south: return "S"
        case .west: return "W"
        }
    }

    func position(in radius: CGFloat) -> CGPoint {
        let offset: CGFloat = 20
        switch self {
        case .north: return CGPoint(x: radius, y: offset)
        case .east:  return CGPoint(x: radius * 2 - offset, y: radius)
        case .south: return CGPoint(x: radius, y: radius * 2 - offset)
        case .west:  return CGPoint(x: offset, y: radius)
        }
    }
}



struct CompassView: View {
    @StateObject private var compass = CompassManager()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 40) {
                Text("羅盤")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                ZStack {
                    // 羅盤底盤
                    Circle()
                        .stroke(lineWidth: 3)
                        .foregroundColor(.gray)
                        .frame(width: 250, height: 250)

                    // 方向文字（固定）
                    ForEach(Direction.allCases, id: \.self) { direction in
                        Text(direction.label)
                            .foregroundColor(direction == .north ? .red : .white)
                            .font(.headline)
                            .position(direction.position(in: 125))
                    }

                    // 指北針箭頭（旋轉）
                    Image(systemName: "location.north.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(compass.heading))
                        .animation(.easeInOut(duration: 0.2), value: compass.heading)

                    // 角度顯示
                    VStack {
                        Spacer()
                        Text("\(Int(compass.heading))° \(directionString(from: compass.heading))")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                .frame(width: 250, height: 250)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            compass.startUpdating()
        }
        .onDisappear {
            compass.stopUpdating()
        }
    }

    // 將角度轉為方向文字
    func directionString(from angle: Double) -> String {
        switch angle {
        case 0..<22.5, 337.5..<360: return "N"
        case 22.5..<67.5: return "NE"
        case 67.5..<112.5: return "E"
        case 112.5..<157.5: return "SE"
        case 157.5..<202.5: return "S"
        case 202.5..<247.5: return "SW"
        case 247.5..<292.5: return "W"
        case 292.5..<337.5: return "NW"
        default: return ""
        }
    }
}

