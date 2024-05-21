//
//  ImpulseManager.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/17/24.
//

import Foundation

enum LabelCoefficients{
    case green
    case yellow
    case red
    
    var coefficients : Double{
        switch self{
        case .green:
            return 1.3
        case .yellow:
            return 1.7
        case .red:
            return 2.1
        }
    }
}

class ImpulseManager: NSObject, ObservableObject {
    //    @Published var currentSpeed: Double = 0
    //    @Published var altitudeLogs: [Double] = []
    
    @Published var impulseLogs: [Double] = []
    @Published var impulseRatio = 50.0
    
    let weight = 50.0
    let diagonalVelocityCriterion = 2.7 // km/h
    var impulseCriterion: Double {
        return self.convertVelocityToImpulse(diagonalVelocityCriterion)
    }
        
    override init() {
        super.init()
        print(self.impulseCriterion)
    }
    
    func convertVelocityToImpulse(_ diagonalVeocity: Double)-> Double{
        return (diagonalVelocityCriterion * weight) / 0.1
    }
    
    func appendToLogs(_ impulse: Double){
        impulseLogs.append(impulse)
    }
    
    func calculateImpulseRatio(_ impulse: Double) -> Double{
        if impulse < impulseCriterion{
            return 0
        }
        
        if impulseCriterion*2 < impulse {
            return 100
        }
        
        return (impulse - impulseCriterion) / (impulseCriterion * 2 - impulseCriterion)
    }
    
    func calculateImpulse(_ currentVerticalVelocity: Double, _ currentHorizontalVelocity: Double) ->Double {
        return sqrt(pow(currentVerticalVelocity, 2)+pow(currentHorizontalVelocity, 2)) * weight / 0.1
    }
    
    
    func calculateAndAppendRecentImpulse(_ altitudeLogs:[Double] ,_ currentSpeed: Double){
        guard altitudeLogs.count > 1 else {
            return
        }
        
        let recentAltitudeChange = altitudeLogs.last! - altitudeLogs[altitudeLogs.count - 2]
        let impulse = self.calculateImpulse(recentAltitudeChange, currentSpeed)
        self.appendToLogs(impulse)
        impulseRatio = self.calculateImpulseRatio(impulse)
    }
    
}
