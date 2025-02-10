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
class HikingRecord {
    @Attribute(.unique) var id: UUID   //구분값
    var title: String       //iOS title
    var duration: Double       //등산소요시간
    // TODO: healthKit에서 조회해 와야 함
    var startDateTime: Date? //시작시간
    // var peakDateTime 필요하네
    var peakDateTime: Date?
    var endDateTime: Date?   //종료시간
    var ascendingDuration: String?
    var descendingDuration: String?
    
    var minHeartRate: Int   //최소심박수
    var maxHeartRate: Int   //최고심박수
    var avgHeartRate: Int   //평균심박수
    
    var startAltitude: Int?  //시작고도 → healthKit에서 처음 고도값 가져오기.
    var peakAltitude: Int?   //정상고도 → 기록된 정보가 있다면 넣어주기
    var endAltitude: Int?    //종료고도 → healthKit에서 마지막 고도값 가져오기.. 근데 필요할까?
    var minAltitude: Int // 최고 고도
    var maxAltitude : Int // 최소 고도
    var totalAltitude: Int // 등반 고도
    var totalDistance: Double?
    
    //impulseLogs 처음 시간 == 하산 시작 시간
    //healthKit에서 하산 시작 시간 이후의 속도의 평균값
    var avgSpeed: Double
    
//    var avgImpulse: Int
    var avgImpulse: Double       //평균충격량
    var painRate: Int? = nil //고통지수
    
    
    @Relationship(deleteRule: .cascade, inverse: \HikingLog.hikingRecord)
    var hikingLogs: [HikingLog]
    
    
    init(id: UUID, title: String, duration: Double, startDateTime: Date? = nil, peakDateTime: Date? = nil, endDateTime: Date? = nil, ascendingDuration: String? = nil, descendingDuration: String? = nil, minHeartRate: Int, maxHeartRate: Int, avgHeartRate: Int, startAltitude: Int? = nil, peakAltitude: Int? = nil, endAltitude: Int? = nil, minAltitude: Int, maxAltitude: Int, totalAltitude: Int, totalDistance: Double? = nil, avgSpeed: Double, avgImpulse: Double, painRate: Int? = nil, hikingLogs: [HikingLog]) {
        self.id = id
        self.title = title
        self.duration = duration
        self.startDateTime = startDateTime
        self.peakDateTime = peakDateTime
        self.endDateTime = endDateTime
        self.ascendingDuration = ascendingDuration
        self.descendingDuration = descendingDuration
        self.minHeartRate = minHeartRate
        self.maxHeartRate = maxHeartRate
        self.avgHeartRate = avgHeartRate
        self.startAltitude = startAltitude
        self.peakAltitude = peakAltitude
        self.endAltitude = endAltitude
        self.minAltitude = minAltitude
        self.maxAltitude = maxAltitude
        self.totalAltitude = totalAltitude
        self.totalDistance = totalDistance
        self.avgSpeed = avgSpeed
        self.avgImpulse = avgImpulse
        self.painRate = painRate
        self.hikingLogs = hikingLogs
    }
}


extension HikingRecord {
    var formattedStartTime: String {
        let dateFormatter = DateFormatter()
        
        // 한국어 형식으로 변환할 포맷
        dateFormatter.dateFormat = "a h시 mm분"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        
        // 변환된 시간 문자열 반환
        return dateFormatter.string(from: startDateTime ?? Date())
    }
    
    var formattedEndTime: String {
        let dateFormatter = DateFormatter()
        
        // 한국어 형식으로 변환할 포맷
        dateFormatter.dateFormat = "a h시 mm분"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        
        // 변환된 시간 문자열 반환
        return dateFormatter.string(from: endDateTime ?? Date())
    }
    
    var formattedEndDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: endDateTime ?? Date())
    }
    
    var formattedDurationTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad // 00:00 형식으로 채움

        if let formattedString = formatter.string(from: duration) {
            // "0:"로 시작하면 해당 부분을 제거하고 반환
            if formattedString.hasPrefix("0:") {
                return String(formattedString.dropFirst(2))
            }
            return formattedString
        } else {
            return "Invalid time"
        }
    }
}
