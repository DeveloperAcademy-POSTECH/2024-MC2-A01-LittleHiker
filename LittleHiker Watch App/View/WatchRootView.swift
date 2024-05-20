//
//  WatchRootView.swift
//  LittleHiker Watch App
//
//  Created by Kyuhee hong on 5/17/24.
//

import SwiftUI

struct WatchRootView: View {
    @ObservedObject var viewModel: HikingViewModel
    @State private var selection = "default"

    var body: some View {
        TabView(selection: $selection) {
            WatchButtonView()
            TabView() {
                WatchMainView(viewModel: viewModel)
                WatchDetailView(viewModel: viewModel)
//                WatchSummaryView(viewModel: viewModel)
            }
            .tag("default")
            .tabViewStyle(.verticalPage)
        }

    }
}

#Preview {
    WatchRootView(viewModel: HikingViewModel())
}
