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
    
    var body: some Scene {
        WindowGroup {
            if viewModel.status == .ready{
                WatchKickOffView(viewModel: viewModel)
            }
            else if viewModel.status == .hiking{
                WatchMainView(viewModel: viewModel)
            }
            
        }
    }
}
