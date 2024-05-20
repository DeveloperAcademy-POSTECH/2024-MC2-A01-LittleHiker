//
//  WatchRootView.swift
//  LittleHiker Watch App
//
//  Created by Kyuhee hong on 5/17/24.
//

import SwiftUI

struct WatchRootView: View {
    @State private var selection = "default"

    var body: some View {
        TabView(selection: $selection) {
            WatchButtonView()
            TabView() {
                WatchMainView(viewModel: HikingViewModel())
                WatchDetailView()
            }
            .tag("default")
            .tabViewStyle(.verticalPage)
        }

    }
}

#Preview {
    WatchRootView()
}
