//
//  HikingRecord.swift
//  LittleHiker
//
//  Created by 백록담 on 5/17/24.
//

import Foundation
import SwiftData

// MARK: - HikingRecord 등산정보
@Model
final class HikingRecord {
    
    @Attribute(.unique) var id: UUID = UUID()   //구분값
    var title: String       //iOS title
    var duration: Int       //등산소요시간
    var startDateTime: Date //시작시간
    // var peakDateTime 필요하네
    var endDateTime: Date   //종료시간
    var startAltitude: Int  //시작고도
    var peakAltitude: Int   //최고고도
    var endAltitude: Int    //종료고도
    var ascendAvgSpeed: Int //등산평균속도
    var descendAvgSpeed: Int//하산평균속도
    var avgForce: Int       //평균충격량
    var painRate: Int? = nil //고통지수
    var minHeartRate: Int   //최소심박수
    var maxHeartRate: Int   //최고심박수
    var avgHeartRate: Int   //평균심박수

    var formattedStartTime: String {
        let dateFormatter = DateFormatter()
        
        // 한국어 형식으로 변환할 포맷
        dateFormatter.dateFormat = "a h시 mm분"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        
        // 변환된 시간 문자열 반환
        return dateFormatter.string(from: startDateTime)
    }
    
    var formattedEndTime: String {
        let dateFormatter = DateFormatter()
        
        // 한국어 형식으로 변환할 포맷
        dateFormatter.dateFormat = "a h시 mm분"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        
        // 변환된 시간 문자열 반환
        return dateFormatter.string(from: endDateTime)
    }
    
    var formattedEndDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: endDateTime)
    }
    
    var formattedDurationTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad // 00:00 형식으로 채움
        
        let seconds = duration * 60
        if let formattedString = formatter.string(from: TimeInterval(seconds)) {
            // "0:"로 시작하면 해당 부분을 제거하고 반환
            if formattedString.hasPrefix("0") {
                return String(formattedString.dropFirst(1))
            }
            return formattedString
        } else {
            return "Invalid time"
        }
    }
    
    init(title: String, duration: Int, startDateTime: Date, endDateTime: Date, startAltitude: Int, peakAltitude: Int, endAltitude: Int, ascendAvgSpeed: Int, descendAvgSpeed: Int, avgForce: Int, minHeartRate: Int, maxHeartRate: Int, avgHeartRate: Int) {
        self.title = title
        self.duration = duration
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.startAltitude = startAltitude
        self.peakAltitude = peakAltitude
        self.endAltitude = endAltitude
        self.ascendAvgSpeed = ascendAvgSpeed
        self.descendAvgSpeed = descendAvgSpeed
        self.avgForce = avgForce
        self.minHeartRate = minHeartRate
        self.maxHeartRate = maxHeartRate
        self.avgHeartRate = avgHeartRate
    }
    
    static var sampleData: [HikingRecord] {
        return [
            HikingRecord(title: "산행 1", duration: 180, startDateTime: Date(), endDateTime: Date().addingTimeInterval(180*60), startAltitude: 300, peakAltitude: 900, endAltitude: 300, ascendAvgSpeed: 6, descendAvgSpeed: 5, avgForce: 3, minHeartRate: 60, maxHeartRate: 160, avgHeartRate: 110),
            HikingRecord(title: "산행 2", duration: 240, startDateTime: Date(), endDateTime: Date().addingTimeInterval(240*60), startAltitude: 400, peakAltitude: 1200, endAltitude: 400, ascendAvgSpeed: 5, descendAvgSpeed: 4, avgForce: 4, minHeartRate: 65, maxHeartRate: 170, avgHeartRate: 115),
            HikingRecord(title: "산행 3", duration: 150, startDateTime: Date(), endDateTime: Date().addingTimeInterval(150*60), startAltitude: 500, peakAltitude: 1000, endAltitude: 500, ascendAvgSpeed: 7, descendAvgSpeed: 6, avgForce: 2, minHeartRate: 70, maxHeartRate: 155, avgHeartRate: 105),
            HikingRecord(title: "산행 4", duration: 200, startDateTime: Date(), endDateTime: Date().addingTimeInterval(200*60), startAltitude: 350, peakAltitude: 950, endAltitude: 350, ascendAvgSpeed: 6, descendAvgSpeed: 5, avgForce: 3, minHeartRate: 68, maxHeartRate: 165, avgHeartRate: 112),
            HikingRecord(title: "산행 5", duration: 220, startDateTime: Date(), endDateTime: Date().addingTimeInterval(220*60), startAltitude: 450, peakAltitude: 1100, endAltitude: 450, ascendAvgSpeed: 5, descendAvgSpeed: 4, avgForce: 4, minHeartRate: 64, maxHeartRate: 160, avgHeartRate: 110),
            HikingRecord(title: "산행 6", duration: 190, startDateTime: Date(), endDateTime: Date().addingTimeInterval(190*60), startAltitude: 400, peakAltitude: 1000, endAltitude: 400, ascendAvgSpeed: 6, descendAvgSpeed: 5, avgForce: 3, minHeartRate: 66, maxHeartRate: 158, avgHeartRate: 108)
        ]
    }
}

