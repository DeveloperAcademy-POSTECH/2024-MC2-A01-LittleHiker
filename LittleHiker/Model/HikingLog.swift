//
//  HikingRecord.swift
//  LittleHiker
//
//  Created by 백록담 on 5/17/24.
//

import Foundation
import SwiftData

// MARK: - HikingLog 등산실시간로그
@Model
class HikingLog {
    @Attribute(.unique) var id: UUID   //구분값
    var hikingRecord: HikingRecord? //로그가 속한 hikingRecord
    var altitude: Int?       //고도
    var speed: Int?           //속도
    var impulse: Double           //충격량
    var heartRate: Int?      //심박수
    var timeStamp: Date      //시간
    
    init(id: UUID, hikingRecord: HikingRecord? = nil, altitude: Int? = nil, speed: Int? = nil, impulse: Double, heartRate: Int? = nil, timeStamp: Date) {
        self.id = id
        self.hikingRecord = hikingRecord
        self.altitude = altitude
        self.speed = speed
        self.impulse = impulse
        self.heartRate = heartRate
        self.timeStamp = timeStamp
    }
}
