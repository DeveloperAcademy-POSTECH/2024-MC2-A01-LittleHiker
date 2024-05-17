//
//  WatchRestView.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/16/24.
//

import SwiftUI

enum GifAnimation: String {
    case run = "run"
    case eat = "eat"
    case peak = "peak"

    var frameCount: Int {
        switch self {
        case .run:
            return 4
        case .eat:
            return 5
        case .peak:
            return 4
        }
    }
    
    func frameImageName(index: Int) -> String {
        "\(self.rawValue)\(index + 1)"
    }
}

struct WatchRestView: View {
    @State var gifAnimation: GifAnimation = .peak
    @State private var frameIndex = 0
    @State private var timer: Timer?
    private let changeTime = 120.0

    var body: some View {
        squirrelGIF
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
