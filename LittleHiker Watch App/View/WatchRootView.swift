//
//  WatchRootView.swift
//  LittleHiker Watch App
//
//  Created by Kyuhee hong on 5/17/24.
//

import SwiftUI

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
                WatchSummaryView(viewModel: viewModel)
            }
            .tag("default")
            .tabViewStyle(.verticalPage)
        }

    }
}

#Preview {
    WatchRootView(viewModel: HikingViewModel(), timeManager: TimeManager())
}
