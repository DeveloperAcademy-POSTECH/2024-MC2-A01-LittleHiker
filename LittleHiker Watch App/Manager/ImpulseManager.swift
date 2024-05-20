//
//  ImpulseManager.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/17/24.
//

import Foundation

class ImpulseManager {
    @Published var currentSpeed: Double = 0
    @Published var altitudeLogs: [Double] = []
    @Published var impulse = 0
        
    func calculateImpulseRate(){
        guard altitudeLogs.count > 1 else {
                    return
                }

        let recentAltitudeChange = altitudeLogs.last! - altitudeLogs[altitudeLogs.count - 2]
        let altitudeChangeSquared = recentAltitudeChange * recentAltitudeChange
        let speedSquared = currentSpeed * currentSpeed
        
        let impulse = sqrt(altitudeChangeSquared + speedSquared)
        
        print(impulse)
        self.impulse = Int(impulse)
    }
    
}
