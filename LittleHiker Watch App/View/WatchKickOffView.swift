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
                CountdownView(viewModel: viewModel, timeManager: timeManager)
            } else {
                KickOffView {
                    showCountdown = true
                }
            }
        }
    }
}

// 시작 버튼 화면
struct KickOffView: View {
    let onStart: () -> Void
    
    var body: some View {
        VStack {
            Button(action: onStart) {
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

// 카운트다운 화면
struct CountdownView: View {
    @ObservedObject var viewModel: HikingViewModel
    @ObservedObject var timeManager: TimeManager
    
    @State private var count: Int = 3
    @State private var progress: Double = 0.0
    @State private var timer: Timer? = nil
    @State private var showReadyText = true
    @State private var highlightBorder = true
    
    var body: some View {
        ZStack {
            // 배경 원
            Circle()
                .stroke(highlightBorder ? Color.main : Color.main.opacity(0.5), lineWidth: 8)
                .frame(width: 100, height: 100)
            
            // 채워지는 원 (Progress 애니메이션)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.main,
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round))
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)

            Text(showReadyText ? "준비" : "\(count)")
                .font(.system(size: 36))
                .fontWeight(.bold)
                .animation(.easeInOut(duration: 0.5), value: count)
        }
        .onAppear {
            startCountdown()
        }
        .onDisappear {
            stopCountdown()
        }
    }
    
    private func startCountdown() {
        var step = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            step += 1
            if step == 1 {
                // 첫 1초 동안 "준비" 텍스트와 테두리 강조
                showReadyText = false
                highlightBorder = true
            } else if count > 1 {
                // 카운트다운 시작 및 진행도 업데이트
                highlightBorder = false // 이후 테두리는 흐려짐
                count -= 1
                progress += 1 / 3.0
            } else {
                // 카운트다운 종료
                stopCountdown()
                startHiking()
            }
        }
    }
    
    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startHiking() {
        if !viewModel.impulseManager.impulseLogs.isEmpty {
            timeManager.initializeManager()
            viewModel.initializeManager()
        }
        timeManager.startHiking()
        viewModel.startHiking()
    }
}
