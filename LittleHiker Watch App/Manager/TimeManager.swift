//
//  TimeManager.swift
//  LittleHiker Watch App
//
//  Created by 백록담 on 5/20/24.
//

import Foundation

class TimeManager: NSObject, ObservableObject {
    let dateFormatter = DateFormatter()

    @Published var date: Date = Date()
    @Published var today: String = ""
    @Published var startTime: String = ""
    @Published var endTime: String = ""

    @Published var timer: Timer?
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning = false
    @Published var displayDuration: String = "00:00:00"
    @Published var ascendingDuration: String = "00:00:00"
    @Published var descendingDuration: String = "00:00:00"
    
    func setToday() {
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        today = dateFormatter.string(from: date) // 현재 시간의 Date를 format에 맞춰 string으로 반환
    }
    
    func setStartTime(_ date: Date) {
        dateFormatter.dateFormat = "hh시 mm분"
        startTime = dateFormatter.string(from: date)
    }
    
    func setEndTime(_ date: Date) {
        dateFormatter.dateFormat = "hh시 mm분"
        endTime = dateFormatter.string(from: date)
    }
    
    func runStopWatch() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
            self.setDisplayDuration()
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
        
    func setDisplayDuration() {
        self.displayDuration = convertTimeIntToTimeString(Int(elapsedTime))
    }
    
    func setAscendingDuration() {
        ascendingDuration = displayDuration
        print("a"+ascendingDuration)
    }
    
    func setDescendingDuration() {
        //종료를 누르면 호출되는 함수
        //종료를 누르면 누른 시간도 여기서 받아준다
        setEndTime(Date())
        //종료시 전체 시간에서 등산 시간을 뺀 시간을 구해줌
        let ascendingTimeInt = convertTimeStringToTimeInt(ascendingDuration)
        let elapsedTimeInt = Int(elapsedTime)
        
        //위에서 얻은 결과값을 descendingTime 에 넣어줌. 이제 이걸로 요약화면이나 아이폰 화면에 보내주면 됨
        descendingDuration = convertTimeIntToTimeString(elapsedTimeInt - ascendingTimeInt)
        print("d"+descendingDuration)
    }
    
}
