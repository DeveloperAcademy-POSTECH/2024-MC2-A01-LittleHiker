//
//  SummaryModel.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/10/24.
//

import Foundation


struct SummaryModel: Codable {
    var minImpulse: Int = 0
    var maxImpulse: Int = 0
    var heartRateAvg: Int = 0
    var minheartRate: Int = 0
    var maxheartRate: Int = 0
    var totalAltitude: Int = 0
    var minAltitude: Int = 0
    var maxAltitude: Int = 0
    var totalDistance: Double = 0.0
    var speedAvg: Double = 0.0 //평균 페이스
    var impulseAvg: Double = 0.0 //평균 충격량
}
