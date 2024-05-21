//
//  LittleHikerApp.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI

@main
struct LittleHiker_Watch_AppApp: App {
    @ObservedObject private var viewModel = HikingViewModel()
    @ObservedObject private var timeManager = TimeManager()
    
    var body: some Scene {
        WindowGroup {
//            WatchDetailView(viewModel: viewModel)
            if viewModel.status == .ready{
                WatchKickOffView(viewModel: viewModel, timeManager: timeManager)
            }
            else if viewModel.status == .hiking{
                WatchRootView(viewModel: viewModel, timeManager: timeManager)
            }
            else if viewModel.status == .hiking{
                WatchSummaryView(viewModel: viewModel)
            }
            
        }
    }
}
