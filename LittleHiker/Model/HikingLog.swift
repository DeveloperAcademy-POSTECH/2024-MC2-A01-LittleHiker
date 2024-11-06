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
final class HikingLog {
    
    @Attribute(.unique) var id: UUID   //구분값
    var hikingRecordId: UUID // HikingRecord Model ID
    var altitude: Int        //고도
    var speed: Int           //속도
    var force: Int           //충격량
    var heartRate: Int       //심박수
    var timestamp: Date      //시간
    
    var hikingRecord: HikingRecord?
    
    init(id: UUID, hikingRecordId: UUID, altitude: Int, speed: Int, force: Int, heartRate: Int, timestamp: Date) {
        self.id = id
        self.hikingRecordId = hikingRecordId
        self.altitude = altitude
        self.speed = speed
        self.force = force
        self.heartRate = heartRate
        self.timestamp = timestamp
    }
}
