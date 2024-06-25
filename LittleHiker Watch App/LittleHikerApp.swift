//
//  LittleHikerApp.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI


@main
struct LittleHiker_Watch_AppApp: App {
    @StateObject private var viewModel = HikingViewModel.shared
    @StateObject private var timeManager = TimeManager()
    
    @WKApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
//            WatchDxetailView(viewModel: viewModel)
            if viewModel.status == .ready{
                WatchKickOffView(viewModel: viewModel, timeManager: timeManager)
            }
            else if viewModel.status != .ready && viewModel.status != .complete {
                WatchRootView(viewModel: viewModel, timeManager: timeManager)
            }
            else if viewModel.status == .complete{
                WatchSummaryView(viewModel: viewModel, timeManager: timeManager)
            }
        }

        
//        #if os(watchOS)
//        WKNotificationScene(
//            controller: NotificationController.self,
//            category: "myNotification")
//        #endif
    }
}
