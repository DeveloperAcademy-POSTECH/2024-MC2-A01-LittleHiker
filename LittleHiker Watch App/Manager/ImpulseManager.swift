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
//    @ObservedObject var viewModelWatch = ViewModelWatch()
    //    @Published var currentSpeed: Double = 0
    //    @Published var altitudeLogs: [Double] = []
    @Published var impulseLogs: [Double] = []
    @Published var impulseRatio = 50.0
    var currentImpulse = 0.0
    var currentMeanOfLastTenImpulseLogs = 0.0
    var prevMeanOfLastTenImpulseLogs = 0.0
    var currentImpulseMeanRatio = 50.0

    //임의
    var localNotification: LocalNotifications
    var redZoneCount: Int = 0
    
    let weight = 50.0
    @Published var diagonalVelocityCriterion: String = "2.95"
    
//    var diagonalVelocityCriterion = Int(viewModelWatch.impulseRate)  // km/h  - TODO: - WatchViewModel에서 전달된 impulseRate 값을 받아서 int로 형변환 해서 쓰고 싶음
    //FIXME: - 임의 테스트용 로그
//    var diagonalVelocityCriterionLogs: [Double] = []
    var impulseCriterionLogs: [Double] = []
    
    var impulseCriterion: Double {
//        print("기준 충격량 \(Double(diagonalVelocityCriterion) ?? 1.0)")
        return self.convertVelocityToImpulse(Double(diagonalVelocityCriterion) ?? 2.95)
    }
        
//    override init() {
//        super.init()
//        print(self.impulseCriterion)
//    }
    
    init(localNotification: LocalNotifications)
    {
        self.localNotification = localNotification
        super.init()
        print("local")
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
//        diagonalVelocityCriterionLogs.append(Double(diagonalVelocityCriterion) ?? -1)
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
//        print("recentAltitudeChange : \(recentAltitudeChange)")
//        print("수평_Vel : \(currentSpeed)")
//        print("경사_Vel : \(sqrt((pow(recentAltitudeChange, 2) + pow(currentSpeed, 2))))")
        currentImpulse = self.calculateImpulse(recentAltitudeChange, currentSpeed)
//        self.appendToLogs(impulse) 밖으로 뺌
//        print("impulse : \(currentImpulse)")
        impulseRatio = self.calculateImpulseRatio(currentImpulse)
//        print("impulseRatio : \(impulseRatio)")
    }
    
    func updateMeanOfLastTenImpulseLogs()->Void {
        currentMeanOfLastTenImpulseLogs = self.getMeanOfLastTenImpulseLogs()
        currentImpulseMeanRatio = self.calculateImpulseRatio(currentMeanOfLastTenImpulseLogs)
    }
    
    func getMeanOfLastTenImpulseLogs() -> Double {
        // Check if the array has less than 10 elements
        if (impulseLogs.count <= 9){
            return impulseLogs.reduce(0, +) / Double(impulseLogs.count)
        }
//        print("meanOfLastTenImpulseLogs called")
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
//        let currentImpulse = self.impulseLogs[self.impulseLogs.count-1]
        let currentImpulse = self.currentMeanOfLastTenImpulseLogs
        let currentImpulseRatio = self.currentImpulseMeanRatio
//        let prevImpulse = self.impulseLogs[self.impulseLogs.count-2]
        let prevImpulseRatio = self.calculateImpulseRatio(prevMeanOfLastTenImpulseLogs)
 
        if prevImpulseRatio >= 0 && prevImpulseRatio < 33 && currentImpulseRatio >= 33 && currentImpulseRatio < 66{
            print("conditionMet!")
//            print("current: \(currentImpulse), prev: \(prevImpulse)")
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
//        let currentImpulse = self.impulseLogs[self.impulseLogs.count-1]
        let currentImpulse = self.currentMeanOfLastTenImpulseLogs
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
//        if impulseCriterion * LabelCoefficients.red.coefficients < self.impulseLogs[self.impulseLogs.count-1] {
//            self.sendWarningNotification()
//        }
    }
}


