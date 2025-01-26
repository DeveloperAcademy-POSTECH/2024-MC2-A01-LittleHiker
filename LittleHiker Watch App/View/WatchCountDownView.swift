//
//  WatchCountDownView.swift
//  LittleHiker Watch App
//
//  Created by Byeol Kim on 1/15/25.
//

import SwiftUI

struct WatchCountDownView: View {
    @ObservedObject var viewModel: HikingViewModel
    @ObservedObject var timeManager: TimeManager
    
    @State private var isReadyPhase = true // "준비" 단계 여부
    @State private var count: Int = 3     // 카운트다운 숫자
    @State private var progress: Double = 0.0 // 원 채우기 상태
    @State private var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            // 배경 원
            Circle()
                .stroke(Color.main.opacity(0.5), lineWidth: 8)
                .frame(width: 100, height: 100)
            
            // 채워지는/깎이는 원
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.main,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(isReadyPhase ? 90 : -90)) // "준비": 아래쪽 시작, "3,2,1": 위쪽 시작
                .animation(.easeOut(duration: 1), value: progress)
            
            // 텍스트 표시
            Text(isReadyPhase ? "준비" : "\(count)")
                .font(.system(size: 36))
                .fontWeight(.bold)
                .animation(.easeInOut(duration: 0.5), value: count)
        }
        .onAppear {
            startReadyPhase()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // "준비" 단계 시작
    private func startReadyPhase() {
        progress = 0.0 // 준비 단계 시작 시 초기화
        withAnimation(.easeOut(duration: 1)) {
            progress = 1.0 // 1초 동안 원이 채워짐
        }
        
        // 1초 뒤에 카운트다운 단계 시작
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isReadyPhase = false // "준비" 단계 종료
            startCountdownPhase() // 카운트다운 시작
        }
    }
    
    // 카운트다운 단계 시작
    private func startCountdownPhase() {
        count = 3
        progress = 1.0 // 원이 채워진 상태에서 시작
        withAnimation(.easeOut(duration: 1)) {
            progress -= 1 / 3.0 // 3분의 1씩 깎임
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if count > 1 {
                // 원이 깎임과 동시에 카운트 감소
                withAnimation(.easeOut(duration: 1)) {
                    progress -= 1 / 3.0 // 3분의 1씩 깎임
                }
                count -= 1
            } else {
                stopTimer() // 타이머 중지
                startHiking() // 하이킹 시작
            }
        }
    }
    
    private func stopTimer() {
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
