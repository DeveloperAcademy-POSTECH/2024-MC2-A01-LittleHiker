//
//  KickOffView.swift
//  LittleHiker Watch App
//
//  Created by 박서현 on 5/13/24.
//

import SwiftUI

struct WatchKickOffView: View {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var viewModel: HikingViewModel
    @ObservedObject var timeManager: TimeManager
    @State private var showCountdown = false
    
    var body: some View {
        VStack {
            if showCountdown {
                WatchCountDownView(viewModel: viewModel, timeManager: timeManager)
            } else {
                VStack {
                    Button(action: {
                        showCountdown = true
                    }) {
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.main)
                            .overlay {
                                Text("시작")
                                    .font(.system(size: 32))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                            }
                            .shadow(color: .main.opacity(0.3), radius: 12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    
                    Text("리틀하이커랑 등산하기")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .padding(.top, 6)
                }
            }
        }
    }
}
