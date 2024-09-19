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
    
    @Attribute(.unique) var id: String   //구분값
    var title: String       //iOS title
    var duration: Int       //등산소요시간
    var startDateTime: Date //시작시간
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
    
    init(id: String, title: String, duration: Int, startDateTime: Date, endDateTime: Date, startAltitude: Int, peakAltitude: Int, endAltitude: Int, ascendAvgSpeed: Int, descendAvgSpeed: Int, avgForce: Int, minHeartRate: Int, maxHeartRate: Int, avgHeartRate: Int) {
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
        self.minHeartRate = minHeartRate
        self.maxHeartRate = maxHeartRate
        self.avgHeartRate = avgHeartRate
    }
}
