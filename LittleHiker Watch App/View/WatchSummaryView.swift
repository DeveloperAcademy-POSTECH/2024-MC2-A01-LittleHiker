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
                Text("총 시간")
                Text("5:20:36")
                    .font(.system(size: 32))
                    .foregroundColor(Color(red: 1, green: 0.84, blue: 0.04))
                
                Divider()
                
                Text("총 거리")
                HStack (spacing: 0) {
                    Text("\(String(format: "%.2f", viewModel.healthKitManager.currentDistanceWalkingRunning))")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.35, green: 0.78, blue: 0.98))
                    Text("KM")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.35, green: 0.78, blue: 0.98))
                        .padding(.top)
                }.frame(height: 30)
                
                Divider()
                
                Text("하산 평균 충격량")
                HStack (spacing: 0) {
                    Text("33")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.01, green: 0.96, blue: 0.92))
                    Text("J")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.01, green: 0.96, blue: 0.92))
                        .padding(.top)
                }.frame(height: 30)
            }
        }
    }
}

#Preview {
    WatchSummaryView(viewModel: HikingViewModel())
}
