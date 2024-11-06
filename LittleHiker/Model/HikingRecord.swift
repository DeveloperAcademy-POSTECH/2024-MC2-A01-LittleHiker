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
    
    @Attribute(.unique) var id: UUID   //구분값
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
//    var avgImpulse: Int
    var avgForce: Int       //평균충격량
    var painRate: Int? = nil //고통지수
    var minHeartRate: Int   //최소심박수
    var maxHeartRate: Int   //최고심박수
    var avgHeartRate: Int   //평균심박수
    
    @Relationship(deleteRule: .cascade, inverse: \HikingLog.hikingRecord)
    var hikingLog: [String: String]
    
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
    
    init(id: UUID, title: String, duration: Int, startDateTime: Date, endDateTime: Date, startAltitude: Int, peakAltitude: Int, endAltitude: Int, ascendAvgSpeed: Int, descendAvgSpeed: Int, avgForce: Int, painRate: Int? = nil, minHeartRate: Int, maxHeartRate: Int, avgHeartRate: Int, hikingLog: [String :String]) {
        self.id = id
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
        self.painRate = painRate
        self.minHeartRate = minHeartRate
        self.maxHeartRate = maxHeartRate
        self.avgHeartRate = avgHeartRate
        self.hikingLog = hikingLog
    }
    
}
