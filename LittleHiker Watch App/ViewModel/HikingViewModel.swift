//
//  HikingViewModel.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/17/24.
//

import Foundation
import CoreLocation
import Combine
import HealthKit

//임시
enum HikingStatus{
    case ready
    case hiking
    case stop
    case peak
}

class HikingViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var status: HikingStatus = .ready //앞으로 관리할 타입 enum으로 관리? ex)준비, 등산, 정지, 정산, 하산
    @Published var isDescent: Bool = true
    private var anchor: HKQueryAnchor?

    //나중에 ios로 넘길 데이터들
    @Published var altitudeLogs: [Double] = []
    @Published var speedLogs: [Double] = []
    @Published var distanceLogs: [Double] = []
    @Published var impulseLogs = 0

    //manager 가져오기
    @Published var healthKitManager = HealthKitManager()
    @Published var coreLocationManager = CoreLocationManager()
    @Published var impulseManager = ImpulseManager()
    
    private var timer: Timer?

    override init() {
        super.init()
   
        updateEveryMinute()
    }
    
    func updateEveryMinute() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.healthKitManager.startHeartRateQuery(quantityTypeIdentifier: .heartRate)
            
            self.coreLocationManager.altitudeLogs.append(self.coreLocationManager.currentAltitude)
            self.coreLocationManager.speedLogs.append(self.coreLocationManager.currentSpeed)
            self.healthKitManager.heartRateLogs.append(self.healthKitManager.currentHeartRate)
            self.healthKitManager.distanceLogs.append(self.healthKitManager.currentDistanceWalkingRunning)
            
            self.impulseManager.calculateImpulseRate(
                altitudeLogs: self.coreLocationManager.altitudeLogs,
                currentSpeed: self.coreLocationManager.currentSpeed
            )
        }
    }

    deinit {
        timer?.invalidate()
    }
}
