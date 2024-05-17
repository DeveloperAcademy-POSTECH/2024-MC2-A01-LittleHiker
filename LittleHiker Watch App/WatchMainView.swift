//
//  WatchMainView.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/16/24.
//

import SwiftUI

//MARK: - WatchMainView

struct WatchMainView: View {
    let gifAnimation: GifAnimation = .run
    @State private var frameIndex = 0
    @State private var timer: Timer?
    @State var isDescent: Bool = true
    @State private var progress: CGFloat = 50

    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .bottom){
                Text("578")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                Text("M")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            }
            Spacer()
            if progress <= 80{
                HStack{
                    Spacer()
                    squirrelGIF
                    Spacer()
                }
            }
            else{
                Text("다람이가\n못 따라오고 있어요🥲\n조금만 기다려주세요")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            Spacer()
            if isDescent{
                progressBar
            }
        }
    }
    
    //MARK: - 다람이GIF
    var squirrelGIF: some View{
        Image(gifAnimation.frameImageName(index: frameIndex))
            .resizable()
            .scaledToFit()
            .frame(width: 106, height: 106)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .rotationEffect(.degrees(isDescent ? 30 : -30))
            .onAppear {
                animationGifTimer()
            }
            .onDisappear {
                stopGifTimer()
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
        .padding(.bottom, 10)
    }
    
    //MARK: - 컬러 반환 함수
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
    
    //MARK: - GIF 스케쥴러
    private func animationGifTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0 / 10.0, repeats: true){ timer in
            frameIndex = (frameIndex + 1) % gifAnimation.frameCount
        }
    }
    
    private func stopGifTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    WatchMainView(isDescent: true)
//    WatchMainView(isDescent: false)
}
