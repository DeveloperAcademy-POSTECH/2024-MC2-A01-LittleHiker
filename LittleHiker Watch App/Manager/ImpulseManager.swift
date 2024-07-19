//
//  ImpulseManager.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/17/24.
//

import Foundation
import SwiftUI

class ImpulseManager: NSObject, ObservableObject {
    @Published var impulseLogs: [Double] = []
    @Published var impulseRatio = 50.0
    var currentImpulse = 0.0
    var currentMeanOfLastTenImpulseLogs = 0.0
    var prevMeanOfLastTenImpulseLogs = 0.0
    var currentImpulseMeanRatio = 50.0
    
    //임의
    var localNotification = LocalNotifications.shared
    var redZoneCount: Int = 0
    
    let weight = 50.0
    @Published var diagonalVelocityCriterion: String = "2.95"
    
    var impulseCriterionLogs: [Double] = []
    
    var impulseCriterion: Double {
        return self.convertVelocityToImpulse(Double(diagonalVelocityCriterion) ?? 2.95)
    }
    
    
    func convertVelocityToImpulse(_ diagonalVeocity: Double)-> Double{
        return ((Double(diagonalVelocityCriterion) ?? 2.95) * weight) / 0.1 / 100 //100나눔
    }
    
    
    func appendToLogs(isRecord: Bool){
        if isRecord {
            impulseLogs.append(currentImpulse)
        }
        else {
            impulseLogs.append(0.0)
        }
        //테스트용
        //        diagonalVelocityCriterionLogs.append(Double (diagonalVelocityCriterion) ?? -1)
        impulseCriterionLogs.append(impulseCriterion)
    }
    
    func calculateImpulseRatio(_ impulse: Double) -> Double{
        if impulse < impulseCriterion{
            return 0
        }
        
        if impulseCriterion * LabelCoefficients.red.coefficients < impulse {
            return 100
        }
        
        return (impulse - impulseCriterion) / (impulseCriterion * 2 - impulseCriterion) * 100
    }
    
    func calculateImpulse(_ currentVerticalVelocity: Double, _ currentHorizontalVelocity: Double) ->Double {
        return sqrt((pow(currentVerticalVelocity, 2) * 3 / 4)
                    + (pow(currentHorizontalVelocity, 2) * 1 / 4)) //수직 속도, 수평 속도가 3:1비율로 적용되게하기
                        * weight / 0.1 / 100 // 단위 줄이기 100 나눔
    }
    
    func findNonZeroMin() -> Double? {
        let nonZeroValues = impulseLogs.filter { $0 != 0 }
        return nonZeroValues.min()
    }
    
    func calculateImpulse(altitudeLogs:[Double] ,currentSpeed: Double){
        guard altitudeLogs.count > 60 else {
            return
        }
        
        let verticalSpeed = calculateVerticalSpeed(altitudeLogs: altitudeLogs)
        print("수직속도 : \(verticalSpeed)km/h")
        currentImpulse = self.calculateImpulse(verticalSpeed, currentSpeed)
        impulseRatio = self.calculateImpulseRatio(currentImpulse)
        
    }
    
    func calculateVerticalSpeed(altitudeLogs: [Double]) -> Double {
        let lastAltitude = altitudeLogs.last!
        
        var changeIndex = altitudeLogs.count - 1
        for i in stride(from: altitudeLogs.count - 2, through: 0, by: -1) {
            if i == 0 || altitudeLogs[i] <= 0.0{
                return 0.0
            }
            if altitudeLogs[i] != lastAltitude {
                
                changeIndex = i
                break
            }
        }
        
        let timeDifference = Double(altitudeLogs.count - 1 - changeIndex)
        if timeDifference > 0{
            let altitudeChange = (lastAltitude - altitudeLogs[changeIndex])
            if altitudeChange < 0 {
                return 0.0
            }
            print("변화 시간 \(timeDifference), 변화고도 : \(altitudeChange)")
            let verticalSpeed = (altitudeChange / timeDifference) * 3.6
            return verticalSpeed
        }
        return 0.0
    }
    
    //TODO: Impulsemanager 처리 과정에 중복되거나 불필요한 로직 뺄 필요가 있어보임
    func processImpulseData(isRecord: Bool) {
        updateMeanOfLastTenImpulseLogs()
        appendToLogs(isRecord: isRecord)
        updateRedZoneCount()
        sendWarningIfConditionMet()
        sendTipsIfConditionMet()
    }
    
    func updateMeanOfLastTenImpulseLogs()->Void {
        currentMeanOfLastTenImpulseLogs = self.getMeanOfLastTenImpulseLogs()
        currentImpulseMeanRatio = self.calculateImpulseRatio(currentMeanOfLastTenImpulseLogs)
    }
    
    func getMeanOfLastTenImpulseLogs() -> Double {
        // Check if the array has less than 10 elements
        if (impulseLogs.count <= 9){
            if impulseLogs.count == 0 {
                return 0
            }
            return impulseLogs.reduce(0, +) / Double(impulseLogs.count)
        }
        
        let lastTenElements = impulseLogs.suffix(10)
        return lastTenElements.reduce(0, +) / Double(10)
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
    
    func isTipsConditionMet() -> Bool {
        if self.impulseLogs.count < 2 {
            return false
        }
        let currentImpulse = self.currentMeanOfLastTenImpulseLogs
        let currentImpulseRatio = self.currentImpulseMeanRatio
        let prevImpulseRatio = self.calculateImpulseRatio(prevMeanOfLastTenImpulseLogs)
        
        if prevImpulseRatio >= 0 && prevImpulseRatio < 33 && currentImpulseRatio >= 33 && currentImpulseRatio < 66{
            prevMeanOfLastTenImpulseLogs = currentImpulse
            return true
        }
        prevMeanOfLastTenImpulseLogs = currentImpulse
        return false
    }
    
    
    func sendTipsNotification()  -> Void {
        localNotification.schedule()
    }
    
    func sendTipsIfConditionMet() -> Void{
        if !self.isTipsConditionMet(){
            return
        }
        self.sendTipsNotification()
    }
    
    func isWarningConditionMet() -> Bool{
//        let currentImpulse = self.currentMeanOfLastTenImpulseLogs
        let currentImpulseRatio = self.currentImpulseMeanRatio
        if 66 <= currentImpulseRatio {
            return true
        }
        return false
    }
    
    func stayedInRedZoneForTooLong() -> Bool {
        if 15 <= redZoneCount {
            return true
        }
        return false
    }
    
    func updateRedZoneCount() -> Void {
        if self.isWarningConditionMet() {
            self.redZoneCount += 1
        }
        else{
            self.redZoneCount = 0
        }
    }
    
    func sendWarningNotification()  -> Void {
        localNotification.schedule2()
    }
    
    func sendWarningIfConditionMet() -> Void {
        if stayedInRedZoneForTooLong() {
            self.sendWarningNotification()
        }
    }
}
