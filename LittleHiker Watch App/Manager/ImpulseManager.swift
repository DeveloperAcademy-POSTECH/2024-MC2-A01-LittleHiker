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
        return (diagonalVelocityCriterion * weight) / 0.1 / 100 //100나눔
    }
    
    
    func appendToLogs(_ impulse: Double){
        impulseLogs.append(impulse)
    }
    
    func calculateImpulseRatio(_ impulse: Double) -> Double{
        if impulse < impulseCriterion{
            return 0
        }
        
        if impulseCriterion * 2 < impulse {
            return 100
        }
        
        return (impulse - impulseCriterion) / (impulseCriterion * 2 - impulseCriterion) * 100
    }
    
    func calculateImpulse(_ currentVerticalVelocity: Double, _ currentHorizontalVelocity: Double) ->Double {
        return sqrt(pow(currentVerticalVelocity, 2)+pow(currentHorizontalVelocity, 2)) * weight / 0.1 / 100 // 단위 줄이기 100 나눔
    }
    
    
    func calculateAndAppendRecentImpulse(altitudeLogs:[Double] ,currentSpeed: Double){
        guard altitudeLogs.count > 1 else {
            return
        }
        
        let recentAltitudeChange = (altitudeLogs.last! - altitudeLogs[altitudeLogs.count - 2]) / 1000 * 60
        print("recentAltitudeChange : \(recentAltitudeChange)")
        print("수평_Vel : \(currentSpeed)")
        print("경사_Vel : \(sqrt((pow(recentAltitudeChange, 2) + pow(currentSpeed, 2))))")
        let impulse = self.calculateImpulse(recentAltitudeChange, currentSpeed)
        self.appendToLogs(impulse)
        print("impulse : \(impulse)")
        impulseRatio = self.calculateImpulseRatio(impulse)
        print("impulseRatio : \(impulseRatio)")

    }
    
}
