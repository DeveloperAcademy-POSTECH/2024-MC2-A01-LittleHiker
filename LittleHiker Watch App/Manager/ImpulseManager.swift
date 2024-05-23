//
//  ImpulseManager.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/17/24.
//

import Foundation
import SwiftUI

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
    //FIXME: - manager파일인데 swiftUI가 들어가는게 이상하긴 함
    @ObservedObject var viewModelWatch = ViewModelWatch()
    //    @Published var currentSpeed: Double = 0
    //    @Published var altitudeLogs: [Double] = []
    @Published var impulseLogs: [Double] = []
    @Published var impulseRatio = 50.0
    
    let weight = 50.0
    @Published var diagonalVelocityCriterion: String = "2.7"
//    var diagonalVelocityCriterion = Int(viewModelWatch.impulseRate)  // km/h  - TODO: - WatchViewModel에서 전달된 impulseRate 값을 받아서 int로 형변환 해서 쓰고 싶음
    //임의 테스트용 로그
    var diagonalVelocityCriterionLogs: [Double] = []
    var impulseCriterionLogs: [Double] = []
    
    var impulseCriterion: Double {
        print("기준 충격량 \(Double(diagonalVelocityCriterion) ?? 1.0)")
        return self.convertVelocityToImpulse(Double(diagonalVelocityCriterion) ?? 2.7)
    }
        
    override init() {
        super.init()
        print(self.impulseCriterion)
    }
    
    func convertVelocityToImpulse(_ diagonalVeocity: Double)-> Double{
        return ((Double(diagonalVelocityCriterion) ?? 2.7) * weight) / 0.1 / 100 //100나눔
    }
    
    
    func appendToLogs(_ impulse: Double){
        impulseLogs.append(impulse)
        //테스트용
        diagonalVelocityCriterionLogs.append(Double(diagonalVelocityCriterion) ?? -1)
        impulseCriterionLogs.append(impulseCriterion)
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
    
    func findNonZeroMin() -> Double? {
        let nonZeroValues = impulseLogs.filter { $0 != 0 }
        return nonZeroValues.min()
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
    
    func getImpulseAvg() -> Double {
        let nonZeroImpulseLogs = impulseLogs.filter { $0 != 0 }

        guard !nonZeroImpulseLogs.isEmpty else {
            return 0.0
        }
        
        let sum = nonZeroImpulseLogs.reduce(0, +)
        
        let average = sum / Double(nonZeroImpulseLogs.count)
        
        return average
    }
}
