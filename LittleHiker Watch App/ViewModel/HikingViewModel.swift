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
    var healthKitManager = HealthKitManager()
    var coreLocationManager = CoreLocationManager()
    var impulseManager = ImpulseManager()
    
    private var timer: Timer?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //밑에 부분은 시작 버튼누르고 321 지나고 나서 실행하게 바꿔야됨
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // 최고의 정확도 대신 배터리 소모 상승
        // 위 옵션 종류 kCLLocationAccuracyBest, kCLLocationAccuracyNearestTenMeters(10m), kCLLocationAccuracyHundredMeters(100m) 등 순으로 정확도, 배터리 상승
        locationManager.distanceFilter = kCLDistanceFilterNone  // 모든 움직임에 대해 업데이트를 받고 싶을 때
        
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateEveryMinute()
            self?.impulseManager.calculateImpulseRate() //TODO: - 이게 맞는지 확인 필요
        }
    }

    func updateEveryMinute() {
        //심박수 업데이트
        healthKitManager.startHeartRateQuery(quantityTypeIdentifier: .heartRate)
        
        //TODO: - 찝찝함..
        coreLocationManager.altitudeLogs.append(coreLocationManager.currentAltitude)
        coreLocationManager.speedLogs.append(coreLocationManager.currentSpeed)
        healthKitManager.heartRateLogs.append(healthKitManager.currentHeartRate)
        healthKitManager.distanceLogs.append(healthKitManager.currentDistanceWalkingRunning)
    }

    deinit {
        timer?.invalidate()
    }
}
