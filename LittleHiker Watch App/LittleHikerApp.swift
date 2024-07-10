//
//  LittleHikerApp.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI
import SwiftData

@main
struct LittleHiker_Watch_AppApp: App {
    @ObservedObject private var viewModel = HikingViewModel.shared
    @StateObject private var timeManager = TimeManager()
    
    @WKApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var modelContainer: ModelContainer = {
        let schema = Schema([CustomComplementaryHikingData.self, LogsWithTimeStamps.self])
        // TODO: - CloudKit을 사용하게 되면 여기에서 cloudKitDatabase 옵션을 추가해줘야 함
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
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
