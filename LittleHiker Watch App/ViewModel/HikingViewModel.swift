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
    private var locationManager = CLLocationManager()
    private var previousLocation: CLLocation?
    private var totalDistance: Double = 0.0 // 총 이동한 거리 변수
    @Published var totalDistanceTraveled: Double = 0.0 // 총 이동 거리 확인용 임시 변수

    @Published var status: HikingStatus = .ready //앞으로 관리할 타입 enum으로 관리? ex)준비, 등산, 정지, 정산, 하산
    @Published var isDescent: Bool = true
    @Published var currentAltitude: Double = 0
    @Published var currentSpeed: Double = 0
    @Published var currentHeartRate: Int = 0
    @Published var currentDistanceWalkingRunning: Double = 0
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
        
            self?.healthKitManager.startHeartRateQuery(quantityTypeIdentifier: .heartRate)
            
            //TODO: - 찝찝함.. 구조체 만들기
            self!.coreLocationManager.altitudeLogs.append(self!.coreLocationManager.currentAltitude)
            self!.coreLocationManager.speedLogs.append(self!.coreLocationManager.currentSpeed)
            self!.healthKitManager.heartRateLogs.append(self!.healthKitManager.currentHeartRate)
            self!.healthKitManager.distanceLogs.append(self!.healthKitManager.currentDistanceWalkingRunning)
            self?.impulseManager.calculateImpulseRate() //TODO: - 이게 맞는지 확인 필요
        }
    }

    deinit {
        timer?.invalidate()
    }
}
