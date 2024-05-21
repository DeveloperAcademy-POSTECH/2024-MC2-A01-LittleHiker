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
    @Published var displayTime: String = "00:00:00"
    @Published var ascendingTime: String = "00:00:00"
    @Published var descendingTime: String = "00:00:00"
    
    func runStopWatch() {
        print("startStopWatch")

        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
            self.setTime()
        }
    }
    
    func pauseStopWatch() {
        print("pauseStopWatch")

        isRunning = false
        timer?.invalidate()
    }
        
    func setTime() {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60

//        let milliseconds = Int((elapsedTime * 100).truncatingRemainder(dividingBy: 100))
//        self.displayTime = String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)

        self.displayTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)


        print("SetTime \(elapsedTime)")

        print("displayTime \(displayTime)")
    }
    
    func setAscendingTime() {
        ascendingTime = displayTime
    }
    
    func setDescendingTime() {
        //
    }
    
    
}
