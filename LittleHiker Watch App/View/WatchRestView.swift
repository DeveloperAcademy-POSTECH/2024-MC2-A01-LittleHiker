//
//  WatchRestView.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/16/24.
//

import SwiftUI

struct WatchRestView: View {
    @State var gifAnimation: GifAnimation = .peak
    @State private var frameIndex = 0
    @State private var timer: Timer?
    private let changeTime = 10.0

    var body: some View {
        ZStack {
            squirrelGIF
                .offset(y: gifAnimation == .eat ? -12 : 0)
                .padding(.bottom,gifAnimation == .eat ? 12 : 0)
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 32)
                .foregroundColor(.gray.opacity(0.3))
                .padding(.top, 140)
                .padding(.horizontal, 9)
                .overlay {
                    Text(gifAnimation == .eat ? "냠냠~ 맛있다~" : "야~~~호~~~!")
                        .font(.system(size: 16))
                        .padding(.top, 140)
                }
        }
    }
    
    var squirrelGIF: some View{
        Image(gifAnimation.frameImageName(index: frameIndex))
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .onAppear {
                animationGifTimer()
                changeGifAnimationAfterDelay()
            }
            .onDisappear{
                stopGifTimer()
            }
    }

    //MARK: - GIF 스케줄
    private func animationGifTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 4.0, repeats: true) { timer in
            frameIndex = (frameIndex + 1) % gifAnimation.frameCount
        }
    }
    
    private func changeGifAnimationAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + changeTime) {
            gifAnimation = .eat
        }
    }
    
    private func stopGifTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    WatchRestView()
}
