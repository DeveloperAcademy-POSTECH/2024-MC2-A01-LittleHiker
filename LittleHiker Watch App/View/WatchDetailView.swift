//
//  ContentView.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI
import HealthKit

struct WatchDetailView: View {
    @ObservedObject var viewModel: HikingViewModel
    @ObservedObject var healthViewModel: HealthKitManager
    @ObservedObject var timeManager: TimeManager
    
    var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                //총 시간
                Text("\(timeManager.displayDuration)")
                    .font(.system(size: 32))
                    .foregroundColor(Color.yellow)
                    .fontWeight(.medium)
                    .frame(height: 32)
                
                //현재 심박수
                HStack (spacing: 0) {
                    Text("\(healthViewModel.currentHeartRate)")
                        .font(.system(size: 32))
                    
                    VStack(alignment: .leading){
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                    }
                    .font(.system(size:24))
                    .padding(.leading, 4)
                }
                
                //현재 페이스
                HStack (spacing: 0) {
                    Text("\(String(format: "%.1f", viewModel.healthKitManager.currentSpeed))")
                        .font(.system(size: 32))
                    
                    VStack{
                        Spacer(minLength: 1)
                        Text("km/h")
                            .font(.system(size: 22))
                    }
                    VStack(alignment: .leading){
                        Text("현재")
                        Text("페이스")
                    }
                    .font(.system(size: 12))
                    .padding(.horizontal)
                }
                .frame(height: 32)
                
                //등반고도
                HStack (spacing: 0) {
                    Text("\(Int(viewModel.coreLocationManager.climbingAltitude))")
                        .font(.system(size: 32))
                    
                    VStack{
                        Spacer(minLength: 1)
                        Text("M")
                            .font(.system(size: 22))
                    }
                    VStack(alignment: .leading){
                        Text("등반")
                        Text("고도")
                    }
                    .font(.system(size: 12))
                    .padding(.horizontal)
                }
                .frame(height: 32)
                
                //총 거리
                HStack (spacing: 0) {
                    Text("\(String(format:"%.2f", viewModel.healthKitManager.currentDistanceWalkingRunning))")// healthkit에서 거리받기
                        .font(.system(size: 32))
                    VStack{
                        Spacer(minLength: 1)
                        Text("km")
                            .font(.system(size: 22))
                    }
                    VStack(alignment: .leading){
                        Text("총")
                        Text("거리")
                    }
                    .font(.system(size: 12))
                    .padding(.horizontal)
                }
                .frame(height: 32)
                
            }
            Spacer()
        }
        .padding(.horizontal, 9)
    }
}

#Preview {
    WatchDetailView(viewModel: HikingViewModel(), healthViewModel: HealthKitManager(), timeManager: TimeManager())
}
