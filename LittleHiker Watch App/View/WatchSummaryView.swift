//
//  ContentView.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI

struct WatchSummaryView: View {
    @ObservedObject var viewModel: HikingViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // todo 이거 navigationTitle 로 지정하면 뜨는건지 확인 필요.
                HStack {
                    Spacer()
                    Text("요약")
                        .foregroundStyle(Color.blue)
                }
                
                //시간
                Text("총 시간")
                    .font(.system(size: 16))
                Text("5:20:36")
                    .font(.system(size: 32))
                    .foregroundColor(Color.yellow)
                    .fontWeight(.medium)
                
                HStack(spacing: 0) {
                    Text("등산시간: ")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("02:10")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                HStack(spacing: 0) {
                    Text("하산시간: ")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("03:10")
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
                    Text("\(String(format: "%.2f", viewModel.healthKitManager.currentDistanceWalkingRunning))")
                        .font(.system(size: 32))
                        .foregroundColor(Color.cyan)
                        .fontWeight(.medium)
                        .padding(.trailing, 2)
                    Text("KM")
                        .font(.system(size: 18))
                        .foregroundColor(Color.cyan)
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
                    Text("33")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.00, green: 0.92, blue: 0.64, opacity: 1.00))
                        .fontWeight(.medium)
                        .padding(.trailing, 2)
                    Text("J")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.00, green: 0.92, blue: 0.64, opacity: 1.00))
                        .fontWeight(.medium)
                        .padding(.top)
                }
                
                HStack(spacing: 0) {
                    Text("범위:")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("10")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("~")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("40")
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
                    Text("100")
                        .font(.system(size: 32))
                        .foregroundColor(Color.red)
                        .padding(.trailing, 4)
                        .fontWeight(.medium)
                    Text("BPM")
                        .font(.system(size: 18))
                        .foregroundColor(Color.red)
                        .padding(.top)
                        .fontWeight(.medium)
                }
                HStack(spacing: 0) {
                    Text("범위:")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("57")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("~")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("156")
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
                    Text("937")
                        .font(.system(size: 32))
                        .foregroundColor(Color.green)
                        .padding(.trailing, 4)
                        .fontWeight(.medium)
                    Text("M")
                        .font(.system(size: 18))
                        .foregroundColor(Color.green)
                        .padding(.top)
                        .fontWeight(.medium)
                }
                
                HStack(spacing: 0) {
                    Text("최고: ")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("937")
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
                    Text("50")
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
                Text("2024년 05월 21일")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                HStack {
                    Text("09시 25분")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text("~")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text("15시 57분")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    WatchSummaryView(viewModel: HikingViewModel())
}
