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
    
    @ObservedObject var viewModel: HikingViewModel
    @ObservedObject var locationViewModel: CoreLocationManager
    @State private var frameIndex = 0
    @State private var timer: Timer?
//    @State private var progress: CGFloat = 50
    
    @State private var isShowing = false
    let alertTitle: String = "충격량 정보"

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                if viewModel.impulseManager.impulseRatio <= 80{
                    HStack{
                        squirrelGIF
                            .padding(.bottom, viewModel.isDescent ? 16 : 0)
                            .onDisappear{
                                stopGifTimer()
                            }
                    }
                }
                else{
                    VStack{
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                            //                            .padding(.horizontal, 9)
                                .frame(height: 80)
                                .foregroundColor(.gray.opacity(0.3))
                                .padding(.bottom, 4)
                            HStack(alignment: .center){
                                Text("다람이가\n못 따라오고 있어요🥲\n조금만 쉬면서 가세요")
                                    .font(.system(size: 16))
                                    .fontWeight(.medium)
                                    .padding(.bottom, 4)
                                    .padding(.leading, 9)
                                Spacer()
                            }
                        }
                        .padding(.top, 100)
                        Spacer()
                    }
                }
            }
            
            HStack(spacing: 0) {
                ZStack {
                    VStack(alignment: .leading, spacing: 0){
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
                                    //                        Text("\(String(format: "%.1f", locationViewModel.currentSpeed))")
                                    //                            .font(.system(size: (viewModel.isDescent ? 22 : 22)))
                                    //                            .fontWeight(.medium)
                                    //                            .foregroundStyle(.green)
                                    //                        Text("km/h")
                                    //                            .font(.system(size: (viewModel.isDescent ? 18 : 18)))
                                    //                            .fontWeight(.medium)
                                    //                            .foregroundStyle(.green)
                                }
                            }
                            Spacer()
                            if viewModel.isDescent{
                                Button(action: {
                                    isShowing = true
                                }) {
                                    Image(systemName: "info")
                                }
                                .alert(isPresented: $isShowing) {
                                    Alert(
                                        title: Text("충격량(IU)"),
                                        message: Text("= 힘(N)/100"),
                                        dismissButton: .default(Text("확인"))
                                    )
                                }
                                .frame(width: 30, height: 30)
                                .background(Color.white.opacity(0.2))
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .buttonStyle(PlainButtonStyle())}
                        }
                        .padding(.top, 4)
                        
                        Spacer()
                        if viewModel.isDescent{
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
                            progressBar
                        }
                    }
                    .padding(.horizontal, 9)
                    .padding(.top, 28)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
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
                if viewModel.status != .hikingStop && viewModel.status != .descendingStop{
                    animationGifTimer()
                }
            }
            .onDisappear {
                stopGifTimer()
            }
            .onChange(of: viewModel.impulseManager.impulseRatio){
                if viewModel.status != .hikingStop && viewModel.status != .descendingStop{
                    animationGifTimer()
                }
            }
            .onChange(of: viewModel.status){
                if viewModel.status == .hikingStop || viewModel.status == .descendingStop{
                    stopGifTimer()
                } else {
                    animationGifTimer()
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
                    .frame(width: geometry.size.width, height: 12)
                HStack{
                    Text(viewModel.impulseManager.impulseLogs.count == 0 ? "--" : "\(Int(viewModel.impulseManager.impulseLogs.last!))")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                }
                .frame(minWidth: 44)
                .frame(height: 24)
                .background(Capsule().fill(colorForValue(viewModel.impulseManager.impulseRatio)))
                .offset(
                    x: min(
                        max(
                            CGFloat(viewModel.impulseManager.impulseRatio / 100 * geometry.size.width) - 25,
                            0
                        ),
                        CGFloat(geometry.size.width - 50)
                    ),
                    y: 0
                )
                .animation(.linear, value: viewModel.impulseManager.impulseRatio)
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
            return 1/4
        case 15..<30:
            return 1/8
        case 30..<45:
            return 1/12
        case 45..<60:
            return 1/16
        case 60...75:
            return 1/20
        case 75...90:
            return 1/24
        case 90...100:
            return 1/28
        default:
            return 1/8
        }
    }
    
    //MARK: - GIF 스케쥴러
    private func animationGifTimer() {
        stopGifTimer()
        // 1.0 / 4.0이면 1초당 이미지 4번 바뀜
        timer = Timer.scheduledTimer(withTimeInterval: speedForValue(viewModel.impulseManager.impulseRatio), repeats: true) { _ in
            frameIndex = (frameIndex + 1) % gifAnimation.frameCount
        }
    }
    
    private func stopGifTimer() {
        timer?.invalidate()
        timer = nil
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
    WatchMainView(viewModel: HikingViewModel(), locationViewModel: HikingViewModel().coreLocationManager)
//    WatchMainView(isDescent: false)
}
