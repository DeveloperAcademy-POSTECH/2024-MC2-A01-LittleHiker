//
//  WatchMainView.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/16/24.
//

import SwiftUI
import WatchKit

//MARK: - WatchMainView

struct WatchMainView: View {
    let gifAnimation: GifAnimation = .run
    
    @ObservedObject var viewModel: HikingViewModel
    @ObservedObject var locationViewModel: CoreLocationManager
    @ObservedObject var localNotification = LocalNotifications.shared
    @State private var frameIndex = 0
    @State private var timer: Timer?
    @State private var lastUpdateTime: TimeInterval = 0
    //    @State private var progress: CGFloat = 50
    
    //시연용 임시방편 모달로해보기
    @State private var isShowingTestA = false
    @State private var isShowingTestB = false
    
    let alertTitle: String = "충격량 정보"
    
    //버퍼 조절 피커에 사용될 변수
    @State private var option = 3
    @State private var selectionOption = Array(0...50)
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headLabel
                if viewModel.impulseManager.currentImpulseMeanRatio <= 80{
                    HStack{
                        squirrelGIF
                            .offset(y : -10)
                            .padding(.bottom, viewModel.isDescent ? 16 : 0)
                    }
                }
                else{
                    if viewModel.isDescent {
                        VStack{
                            ZStack {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                //                            .padding(.horizontal, 9)
                                    .frame(height: 60)
                                    .foregroundColor(.gray.opacity(0.3))
                                    .padding(.bottom, 4)
                                HStack(alignment: .center){
                                    Text("다람이가\n못 따라오고 있어요🥲\n조금만 쉬면서 가세요")
                                        .font(.system(size: 14))
                                        .fontWeight(.medium)
                                        .padding(.bottom, 4)
                                        .padding(.leading, 9)
                                    Spacer()
                                }
                            }
                            .padding(.top, 3)
                            Spacer()
                        }
                    }
                    else {
                        HStack{
                            squirrelGIF
                                .offset(y : -10)
                                .padding(.bottom, viewModel.isDescent ? 16 : 0)
                        }
                    }
                }
                Spacer()
            }
            if viewModel.isDescent{
                progressBarLabel
                    .padding(.top, 108)
                progressBar
                    .padding(.top, 138)
            }
        }
        .padding(.horizontal, 9)
        .edgesIgnoringSafeArea(.top)
    }
    //MARK: - progressbar Label
    var progressBarLabel : some View{
        HStack(alignment: .bottom, spacing: 0){
            Text("충격량")
                .font(.system(size:14))
            //                                .foregroundStyle(.gray)
            Text("(IU)")
                .font(.system(size:14))
                .foregroundStyle(.gray)
            Spacer()
            Text("\(Int(viewModel.impulseManager.impulseCriterion * LabelCoefficients.red.coefficients))")
                .font(.system(size:14))
                .foregroundStyle(.gray)
        }
        .padding(.bottom, 4)
    }
    
    //MARK: - HEAD LABEL
    var headLabel: some View{
        HStack(alignment: .top){
            VStack(alignment: .leading){
                Text("현재 고도")
                    .font(.system(size:(viewModel.isDescent ? 16 : 18)))
                HStack(alignment: .bottom, spacing: 0){
                    Text("\(Int(locationViewModel.currentAltitude))")
                        .font(.system(size: (viewModel.isDescent ? 22 : 32)))
                        .fontWeight(.medium)
                        .foregroundStyle(.green)
                    Text("M")
                        .font(.system(size: (viewModel.isDescent ? 18 : 22)))
                        .fontWeight(.medium)
                        .foregroundStyle(.green)
                        .padding(.leading, 2)
                }
                //현재 속도 테스트용
//                HStack(alignment: .bottom, spacing: 0){
//                    Text("\(String(format: "%.2f", viewModel.healthKitManager.currentSpeed))Km/h")
//                        .font(.system(size: (viewModel.isDescent ? 22 : 32)))
//                        .fontWeight(.medium)
//                        .foregroundStyle(.green)
//                }
//                Text("\(String(format: "%.2f", viewModel.healthKitManager.currentDistanceWalkingRunning))Km")
//                    .font(.system(size: (viewModel.isDescent ? 22 : 32)))
//                    .fontWeight(.medium)
//                    .foregroundStyle(.green)
            }
            Spacer()
        }
        .padding(.horizontal, 9)
        .padding(.top, 32)
    }
    
    
    //MARK: - 다람이GIF
    var squirrelGIF: some View{
        Image(gifAnimation.frameImageName(index: frameIndex))
            .resizable()
            .scaledToFit()
            .frame(width: 106, height: 106)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .rotationEffect(.degrees(viewModel.isDescent ? 30 : -30))
            .background(Color.clear)
            .onAppear {
                if viewModel.status != .hikingPause && viewModel.status != .descendingPause{
                    startGifAnimation()
                }
            }
            .onDisappear {
                stopGifAnimation()
            }
            .onChange(of: viewModel.impulseManager.currentImpulseMeanRatio){
                if viewModel.status != .hikingPause && viewModel.status != .descendingPause{
                    startGifAnimation()
                }
            }
            .onChange(of: viewModel.status){
                if viewModel.status == .hikingPause || viewModel.status == .descendingPause{
                    stopGifAnimation()
                } else {
                    startGifAnimation()
                }
            }
    }
    
    //MARK: - GIF 스케쥴러
    private func startGifAnimation() {
        stopGifAnimation() // 중복 실행 방지

        lastUpdateTime = Date().timeIntervalSince1970
        let frameDuration = speedForValue(viewModel.impulseManager.currentImpulseMeanRatio)

        timer = Timer.scheduledTimer(withTimeInterval: frameDuration, repeats: true) { _ in
            let currentTime = Date().timeIntervalSince1970
            let elapsedTime = currentTime - self.lastUpdateTime

            // 오차 보정을 위해 프레임을 정확히 계산
            let framesToAdvance = Int(elapsedTime / frameDuration)
            if framesToAdvance > 0 {
                self.frameIndex = (self.frameIndex + framesToAdvance) % self.gifAnimation.frameCount
                self.lastUpdateTime += frameDuration * Double(framesToAdvance)
            }
        }
    }

    private func stopGifAnimation() {
        timer?.invalidate()
        timer = nil
    }

    private func restartGifAnimation() {
        startGifAnimation()
    }
    
    //MARK: - 프로그래스바
    var progressBar: some View{
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Image("progressbar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: 12)
                HStack{
                    Text(viewModel.impulseManager.impulseLogs.count == 0 ? "--" :
                            "\(Int(viewModel.impulseManager.currentMeanOfLastTenImpulseLogs))")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                }
                .frame(minWidth: 44)
                .frame(height: 24)
                .background(Capsule().fill(colorForValue(viewModel.impulseManager.currentImpulseMeanRatio)))
                .offset(
                    x: min(
                        max(
                            CGFloat(viewModel.impulseManager.currentImpulseMeanRatio / 100 * geometry.size.width) - 25,
                            0
                        ),
                        CGFloat(geometry.size.width - 50)
                    ),
                    y: 0
                )
                .animation(.linear, value: viewModel.impulseManager.currentImpulseMeanRatio)
            }
        }
        .frame(height: 12)
    }
    
    //MARK: - 컬러 반환 함수
    func colorForValue(_ value: CGFloat) -> Color {
        switch value {
        case 0..<30:
            return Color(red: 0.40, green: 1.00, blue: 0.40, opacity: 1.00)
        case 30..<60:
            return Color(red: 1.00, green: 1.00, blue: 0.40, opacity: 1.00)
        case 60...100:
            return Color(red: 1.00, green: 0.40, blue: 0.40, opacity: 1.00)
        default:
            return Color(red: 1.00, green: 1.00, blue: 0.40, opacity: 1.00)
        }
    }
    
    func speedForValue(_ value: CGFloat) -> Double {
        switch value {
        case 0..<15:
            return 1.0 / 4.0
        case 15..<30:
            return 1.0 / 8.0
        case 30..<45:
            return 1.0 / 12.0
        case 45..<60:
            return 1.0 / 16.0
        case 60...75:
            return 1.0 / 20.0
        case 75...90:
            return 1.0 / 24.0
        case 90...100:
            return 1.0 / 28.0
        default:
            return 1.0 / 8.0
        }
    }
}

//MARK: - InpulseInfoView
struct InpulseInfoView: View {
    var body: some View {
        VStack {
            Text("충격량(IU) = 힘(N)/100")
        }
    }
}
#Preview {
    WatchMainView(viewModel: HikingViewModel.shared, locationViewModel: HikingViewModel.shared.coreLocationManager)
    //    WatchMainView(isDescent: false)
}
