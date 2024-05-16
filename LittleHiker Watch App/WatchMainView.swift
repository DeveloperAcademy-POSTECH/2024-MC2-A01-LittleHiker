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
            HStack(alignment: .bottom){
                Text("578")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
//                    .padding(.leading, 10)
                Text("M")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                Spacer()
            }
            Image(gifAnimation.frameImageName(index: frameIndex))
                .resizable()
                .scaledToFit()
                .frame(width: 106, height: 106)
//                .background(.red)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .rotationEffect(.degrees(isDescent ? 25 : -25))
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1.0 / 10.0, repeats: true){ timer in
                        frameIndex = (frameIndex + 1) % gifAnimation.frameCount
                    }
                }
            Spacer()
            if isDescent{
                progressBar
            }
        }
    }
    //MARK: - 프로그래스바
    var progressBar: some View{
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Image("progressbar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width)

                Text("\(Int(progress))")
//                    .font(.system(size: 18, weight: .semibold))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .background(Capsule().fill(colorForValue(progress)))
                    .offset(x: min(CGFloat(self.progress/100) * geometry.size.width - 21, geometry.size.width - 50), y:0)
                    .animation(.linear, value: progress)
            }
        }
        .frame(height: 20)
        .padding(.bottom, 20)
    }
    
    func colorForValue(_ value: CGFloat) -> Color {
        switch value {
        case 0..<30:
            return .green
        case 30..<60:
            return .yellow
        case 60...100:
            return .red
        default:
            return .yellow
        }
    }
}

#Preview {
    WatchMainView(isDescent: true)
//    WatchMainView(isDescent: false)
}
