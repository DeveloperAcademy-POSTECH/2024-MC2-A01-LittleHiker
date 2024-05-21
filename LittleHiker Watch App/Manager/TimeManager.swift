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
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
            self.setDisplayTime()
        }
    }
    
    func pauseStopWatch() {
        isRunning = false
        timer?.invalidate()
    }
    
    func convertTimeIntToTimeString(_ timeInterval: Int) -> String {
        let hours = timeInterval / 3600
        let minutes = (timeInterval % 3600) / 60
        let seconds = timeInterval % 60
        let result = String(format: "%02d:%02d:%02d", hours, minutes, seconds)

        return result
    }
    
    func convertTimeStringToTimeInt(_ timeString: String) -> Int {
        let timeArray = timeString.components(separatedBy: ":")
        let hour = Int(timeArray[0]) ?? 0
        let minute = Int(timeArray[1]) ?? 0
        let second = Int(timeArray[2]) ?? 0
        let result = hour*3600 + minute*60 + second
            
        return result
    }
        
    func setDisplayTime() {
        self.displayTime = convertTimeIntToTimeString(Int(elapsedTime))
    }
    
    func setAscendingTime() {
        ascendingTime = displayTime
        print("a"+ascendingTime)
    }
    
    func setDescendingTime() {
        //종료를 누르면 호출되는 함수
        //종료시 전체 시간에서 등산 시간을 뺀 시간을 구해줌
        let ascendingTimeInt = convertTimeStringToTimeInt(ascendingTime)
        let elapsedTimeInt = Int(elapsedTime)
        
        //위에서 얻은 결과값을 descendingTime 에 넣어줌. 이제 이걸로 요약화면이나 아이폰 화면에 보내주면 됨
        descendingTime = convertTimeIntToTimeString(elapsedTimeInt - ascendingTimeInt)
        print("d"+descendingTime)
    }
    
    
}
