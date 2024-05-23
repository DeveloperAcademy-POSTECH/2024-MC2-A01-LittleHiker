//
//  ContentView.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI


struct WatchSummaryView: View {
    @ObservedObject var viewModel: HikingViewModel
    @ObservedObject var timeManager: TimeManager
    
    var body: some View {
        ZStack {
            //스크롤 가능한 내용
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    //시간
                    Text("총 시간")
                        .font(.system(size: 16))
                    Text("\(timeManager.displayDuration)")
                        .font(.system(size: 32))
                        .foregroundColor(Color.yellow)
                        .fontWeight(.medium)
                    
                    HStack(spacing: 0) {
                        Text("등산시간: ")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("\(timeManager.ascendingDuration)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 0) {
                        Text("하산시간: ")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("\(timeManager.descendingDuration)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    //거리
                    Text("총 거리")
                        .font(.system(size: 16))
                        .padding(.top, 8)
                    HStack (spacing: 0) {
                        Text("\(String(format: "%.2f", viewModel.summaryModel.totalDistance))")
                            .font(.system(size: 32))
                            .foregroundColor(Color.cyan)
                            .fontWeight(.medium)
                            .padding(.trailing, 2)
                        Text("KM")
                            .font(.system(size: 22))
                            .foregroundColor(Color.cyan)
                            .fontWeight(.medium)
                            .padding(.top)
                    }
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    //평균 페이스
                    Text("평균 페이스")
                        .font(.system(size: 16))
                        .padding(.top, 8)
                    HStack (spacing: 0) {
                        Text("\(String(format: "%.2f", viewModel.summaryModel.speedAvg))")
                            .font(.system(size: 32))
                            .foregroundColor(Color.mint)
                            .fontWeight(.medium)
                            .padding(.trailing, 2)
                        Text("km/h")
                            .font(.system(size: 22))
                            .foregroundColor(Color.mint)
                            .fontWeight(.medium)
                            .padding(.top)
                    }
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    //충격량
                    Text("하산 평균 충격량")
                        .font(.system(size: 16))
                        .padding(.top, 8)
                    HStack (spacing: 0) {
                        Text("\(String(format: "%.2f", viewModel.summaryModel.impulseAvg))")
                            .font(.system(size: 32))
                            .foregroundColor(Color(red: 0.00, green: 0.92, blue: 0.64, opacity: 1.00))
                            .fontWeight(.medium)
                            .padding(.trailing, 2)
                        Text("f")
                            .font(.system(size: 22))
                            .foregroundColor(Color(red: 0.00, green: 0.92, blue: 0.64, opacity: 1.00))
                            .fontWeight(.medium)
                            .padding(.top)
                    }
                    HStack(spacing: 0) {
                        Text("범위:")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("\(viewModel.summaryModel.minImpulse)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("~")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("\(viewModel.summaryModel.maxImpulse)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("J")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    //심박수
                    Text("평균 심박수")
                        .font(.system(size: 16))
                        .padding(.top, 8)
                    HStack (spacing: 0) {
                        Text("\(viewModel.summaryModel.heartRateAvg)")
                            .font(.system(size: 32))
                            .foregroundColor(Color.red)
                            .padding(.trailing, 4)
                            .fontWeight(.medium)
                        Text("BPM")
                            .font(.system(size: 22))
                            .foregroundColor(Color.red)
                            .padding(.top)
                            .fontWeight(.medium)
                    }
                    HStack(spacing: 0) {
                        Text("범위:")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("\(viewModel.summaryModel.minheartRate)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("~")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("\(viewModel.summaryModel.maxheartRate)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("BPM")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    //고도
                    Text("등반고도")
                        .font(.system(size: 16))
                        .padding(.top, 8)
                    HStack (spacing: 0) {
                        Text("\(viewModel.summaryModel.totalAltitude)")
                            .font(.system(size: 32))
                            .foregroundColor(Color.green)
                            .padding(.trailing, 4)
                            .fontWeight(.medium)
                        Text("M")
                            .font(.system(size: 22))
                            .foregroundColor(Color.green)
                            .padding(.top)
                            .fontWeight(.medium)
                    }
                    
                    HStack(spacing: 0) {
                        Text("최고: ")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("\(viewModel.summaryModel.maxAltitude)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("M")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 0) {
                        Text("최저: ")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("\(viewModel.summaryModel.minAltitude)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text("M")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    //기록 타임
                    Text("\(timeManager.today)")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    HStack {
                        Text("\(timeManager.startTime)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text("~")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text("\(timeManager.endTime)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 9)
                .padding(.top, 60)
            }
            
            VStack{
                //navigationbar 역할
                HStack(spacing: 0) {
                    Button(action: {
                        viewModel.status = .ready
                    }, label: {
                        Image(systemName: "xmark")
                            .frame(width: 16, height: 16)
                    })
                    .frame(width: 30, height: 30)
                    .background(Color.white.opacity(0.2))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .buttonStyle(PlainButtonStyle())
                    .padding(.leading, 9)
                    Spacer()
                    Text("요약")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.main)
                        .padding(.trailing, 9.5)
                }
                .padding(.bottom, 8)
                .padding(.top, 24)
                .background(.ultraThinMaterial)
                .zIndex(1)
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    WatchSummaryView(viewModel: HikingViewModel(), timeManager: TimeManager())
}
