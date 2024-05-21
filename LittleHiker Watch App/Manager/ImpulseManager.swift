//
//  ImpulseManager.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/17/24.
//

import Foundation

class ImpulseManager: NSObject, ObservableObject {
//    @Published var currentSpeed: Double = 0
//    @Published var altitudeLogs: [Double] = []
    @Published var impulseLogs = 0
    let weight = 50.0
        
    func calculateImpulseRate(altitudeLogs:[Double] , currentSpeed: Double){
        guard altitudeLogs.count > 1 else {
                    return
                }

        let recentAltitudeChange = altitudeLogs.last! - altitudeLogs[altitudeLogs.count - 2]
        let altitudeChangeSquared = recentAltitudeChange * recentAltitudeChange
        let speedSquared = currentSpeed * currentSpeed
        
        let impulse = sqrt(altitudeChangeSquared + speedSquared) * weight / 0.1
        
        print(impulse)
        self.impulseLogs = Int(impulse)
    }
    
}
