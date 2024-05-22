//
//  WatchRootView.swift
//  LittleHiker Watch App
//
//  Created by Kyuhee hong on 5/17/24.
//

import SwiftUI
import UserNotifications

struct WatchRootView: View {
    @ObservedObject var viewModel: HikingViewModel
    @ObservedObject var timeManager: TimeManager
    @State private var selection = "default"

    var body: some View {
        TabView(selection: $selection) {
            WatchButtonView(viewModel: viewModel, timeManager: timeManager)
            TabView() {
                if viewModel.status == .hiking{
                    WatchMainView(viewModel: viewModel, locationViewModel: viewModel.coreLocationManager)
                }
                else if viewModel.status == .peak{
                    WatchRestView()
                }
                WatchDetailView(viewModel: viewModel, healthViewModel: viewModel.healthKitManager, timeManager: timeManager)
                WatchSummaryView(viewModel: viewModel, timeManager: timeManager)
            }
            .tag("default")
            .tabViewStyle(.verticalPage)
        }
        .onAppear {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound]){ granted, error in
                    if granted {
                        print("로컬 알림 권한이 허용되었습니다")
                    } else {
                        print("로컬 알림 권한이 허용되지 않았습니다")
                    }
                }
        }
    }
}

#Preview {
    WatchRootView(viewModel: HikingViewModel(), timeManager: TimeManager())
}
