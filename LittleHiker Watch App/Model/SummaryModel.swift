//
//  SummaryModel.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/10/24.
//

import Foundation

struct SummaryModel: Codable {
    // TODO: 정상 눌렀을 때 시간, 고도 기록
    var peakDateTime : Date?
    var peakAltitude : Int?
    var ascendingDuration : String?
    var descendingDuration : String?
    
    var minHeartRate: Int = 0
    var maxHeartRate: Int = 0
    var avgHeartRate: Int = 0 //
    
    var minAltitude: Int = 0 
    var maxAltitude: Int = 0
    var totalAltitude: Int = 0
    
    var totalDistance: Double = 0.0
    
    var avgSpeed: Double = 0.0 //평균속도

    var minImpulse: Int = 0 //최소 충격량
    var maxImpulse: Int = 0 //최대 충격량
    var avgImpulse: Double = 0.0 //평균 충격량
}

//iOS의 hikingRecord에 있고 watchd에는 없는 것
// startAltitude
// startDateTime, endDateTime
// duration
// ascendingSpeed, DescendingSpeed
