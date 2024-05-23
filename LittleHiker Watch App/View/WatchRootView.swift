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
        NavigationStack {
            TabView(selection: $selection) {
                WatchButtonView(viewModel: viewModel, timeManager: timeManager, selection: $selection)
                    .tag("buttonView")
                TabView() {
                    if viewModel.status != .peak{
                        WatchMainView(viewModel: viewModel, locationViewModel: viewModel.coreLocationManager)
                    }
                    else {
                        WatchRestView()
                    }
                    WatchDetailView(viewModel: viewModel, healthViewModel: viewModel.healthKitManager, timeManager: timeManager)
                    WatchSummaryView(viewModel: viewModel, timeManager: timeManager)
                }
                .tag("default")
                .tabViewStyle(.verticalPage)
            }
            
        }
    }
}

#Preview {
    WatchRootView(viewModel: HikingViewModel(), timeManager: TimeManager())
}
