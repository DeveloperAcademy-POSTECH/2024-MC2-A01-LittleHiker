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
    @Published var status: HikingStatus = .ready //앞으로 관리할 타입 enum으로 관리? ex)준비, 등산, 정지, 정산, 하산
    @Published var isDescent: Bool = true
    @Published var currentAltitude: Double = 0
    @Published var currentSpeed: Double = 0
    
    //나중에 ios로 넘길 데이터들
    @Published var altitudeRecords: [Double] = []
    @Published var speedRecords: [Double] = []

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
            self?.updateAltitudes()
        }
    }

    func updateAltitudes() {
        altitudeRecords.append(currentAltitude)
        speedRecords.append(currentSpeed)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentAltitude = location.altitude
            self.currentSpeed = location.speed
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription) : \(currentAltitude),\(currentAltitude)")
    }

    deinit {
        timer?.invalidate()
    }
}
