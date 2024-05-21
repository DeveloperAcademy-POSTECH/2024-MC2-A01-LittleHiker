//
//  TimeManager.swift
//  LittleHiker Watch App
//
//  Created by 백록담 on 5/20/24.
//

import Foundation

class TimeManager: NSObject, ObservableObject {
    @Published var timer: Timer?
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning = false
    @Published var displayTime: String = "00:00.00"
    
//    var formattedElapsedTime: String {
//        let minutes = Int(elapsedTime) / 60
//        let seconds = Int(elapsedTime) % 60
//        let milliseconds = Int((elapsedTime * 100).truncatingRemainder(dividingBy: 100))
//        time = String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
//        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
//    }
    
    func startStopWatch() {
        print("startStopWatch")

        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.elapsedTime += 0.01
            self.setTime()
        }
    }
    
    func pauseStopWatch() {
        print("pauseStopWatch")

        isRunning = false
        timer?.invalidate()
    }
    
    func resumeStopWatch() {
        print("resumeStopWatch")

        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.elapsedTime += 0.01
            self.setTime()
        }
    }
    
    func resetStopWatch() {
        print("resetStopWatch")

        isRunning = false
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
    }
    
    func setTime() {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let milliseconds = Int((elapsedTime * 100).truncatingRemainder(dividingBy: 100))
        self.displayTime = String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
        print("SetTime \(displayTime)")
    }
}
