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
    @Published var currentDistanceWalkingRunning: Int = 0
    private var anchor: HKQueryAnchor?

    //나중에 ios로 넘길 데이터들
    @Published var altitudeRecords: [Double] = []
    @Published var speedRecords: [Double] = []
    @Published var heartRateRecords: [Int] = []
    @Published var impulse = 0

    private var timer: Timer?

    //MARK: - HKHealthStore 불러오기
    let healthStore = HKHealthStore()
    
    let heartRateQuantity = HKUnit(from: "count/min")
        
    let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .stepCount)!, HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!])
    let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .stepCount)!, HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!])
    
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //밑에 부분은 시작 버튼누르고 321 지나고 나서 실행하게 바꿔야됨
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // 최고의 정확도 대신 배터리 소모 상승
        // 위 옵션 종류 kCLLocationAccuracyBest, kCLLocationAccuracyNearestTenMeters(10m), kCLLocationAccuracyHundredMeters(100m) 등 순으로 정확도, 배터리 상승
        locationManager.distanceFilter = kCLDistanceFilterNone  // 모든 움직임에 대해 업데이트를 받고 싶을 때
        
        //healthkit 허가
        autorizeHealthKit()
        startTimer()
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateEveryMinute()
            self?.calculateImpulseRate()
        }
    }

    func updateEveryMinute() {
        //심박수 업데이트
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
        
        altitudeRecords.append(currentAltitude)
        speedRecords.append(currentSpeed)
        heartRateRecords.append(currentHeartRate)
    }

    // 위치가 바뀔 때 호출 됨
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentAltitude = location.altitude
            if location.speed == -1 {
                if speedRecords.isEmpty{
                    self.currentSpeed = 0
                } else {
                    self.currentSpeed = speedRecords.last!
                }
            }
            else {
                self.currentSpeed = location.speed * 3.6
            }
            // 총 이동한 거리 구하기
            if let previousLocation = self.previousLocation {
                let distance = location.distance(from: previousLocation)
                self.totalDistance += distance
                self.totalDistanceTraveled = self.totalDistance / 1000 //km변환
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription) : \(currentAltitude),\(currentAltitude)")
    }
    
         //MARK: - 여기부터는 심박수 쿼리
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        // 1
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        // 2
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            // 3
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            
            self.process(samples, type: quantityTypeIdentifier)
            
        }
        
        // 4
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        // 5
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            self.currentHeartRate = Int(lastHeartRate)
        }
    }
    
    
    deinit {
        timer?.invalidate()
    }
    
    func calculateImpulseRate(){
        guard altitudeRecords.count > 1 else {
                    return
                }

        let recentAltitudeChange = altitudeRecords.last! - altitudeRecords[altitudeRecords.count - 2]
        let altitudeChangeSquared = recentAltitudeChange * recentAltitudeChange
        let speedSquared = currentSpeed * currentSpeed
        
        let impulse = sqrt(altitudeChangeSquared + speedSquared)
        
        print(impulse)
        self.impulse = Int(impulse)
    }
}
