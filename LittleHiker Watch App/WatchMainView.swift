//
//  WatchMainView.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/16/24.
//

import SwiftUI

//MARK: - GIF 파일 관리

enum GifAnimation: String {
    case run = "run"
    case eat = "eat"

    var frameCount: Int {
        switch self {
        case .run:
            return 4
        case .eat:
            return 3
        }
    }
    
    func frameImageName(index: Int) -> String {
        "\(self.rawValue)\(index + 1)"
    }
}

//MARK: - WatchMainView

struct WatchMainView: View {
    let gifAnimation: GifAnimation = .run
    @State private var frameIndex = 0
    @State var isDescent: Bool = true
    @State private var progress: CGFloat = 50


    var body: some View {
        VStack{
            if !isDescent{
                HStack(alignment: .bottom){
                    Text("523")
                        .font(.system(size: 31, weight: .bold))
                        .foregroundStyle(.green)
                        .padding(.leading, 20)
                    Text("M")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.green)
                    Spacer()
                }
            }
            Image(gifAnimation.frameImageName(index: frameIndex))
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(isDescent ? 25 : -25))
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1.0 / 10.0, repeats: true){ timer in
                        frameIndex = (frameIndex + 1) % gifAnimation.frameCount
                    }
                }
            if isDescent{
                progressBar
            }
        }
    }
    //MARK: - 프로그래스바
    var progressBar: some View{
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
//                Rectangle()
//                    .frame(width: min(CGFloat(self.progress/100) * geometry.size.width, geometry.size.width), height: 20)
//                    .foregroundColor(colorForValue(progress))
//                    .animation(.linear, value: progress)
                Rectangle()
                    .frame(width: CGFloat(33/100) * geometry.size.width, height: 20)
                    .foregroundColor(.red)
                
                Text("\(Int(progress))%")
                    .font(.system(size: 27, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .background(Capsule().fill(colorForValue(progress)))
                    .offset(x: min(CGFloat(self.progress/100) * geometry.size.width - 30, geometry.size.width - 50), y:0)
                    .animation(.linear, value: progress)
            }
        }
        .frame(height: 20)
        .padding()
    }
    
    func colorForValue(_ value: CGFloat) -> Color {
        switch value {
        case 0..<20:
            return .red
        case 20..<40:
            return .orange
        case 40..<60:
            return .yellow
        case 60..<80:
            return .green
        case 80...100:
            return .blue
        default:
            return .blue
        }
    }
}

#Preview {
//    WatchMainView(isDescent: true)
    WatchMainView(isDescent: false)
}
