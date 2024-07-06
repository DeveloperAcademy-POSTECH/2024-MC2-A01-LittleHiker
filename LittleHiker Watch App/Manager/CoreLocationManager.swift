//
//  CoreLocationManager.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/17/24.
//

import Foundation
import CoreLocation 

class CoreLocationManager : NSObject, CLLocationManagerDelegate, ObservableObject {
    private var locationManager = CLLocationManager()
    private var previousLocation: CLLocation?
    @Published var totalDistanceTraveled: Double = 0.0 // 총 이동 거리 확인용 임시 변수
    
    @Published var currentAltitude: Double = 0
    @Published var currentSpeed: Double = 0
    @Published var verticalSpeed: Double = 0.0

    //나중에 ios로 넘길 데이터들
    @Published var altitudeLogs: [Double] = []
    @Published var speedLogs: [Double] = []
    //필요없어서 삭제

    //등반 고도 값
    @Published var climbingAltitude: Double = 0.0
    
    private var timer: Timer?
    private let minimumDistance: Double = 20 // 무시할 최소 거리 (단위: 미터)
    //알람용
    private var notificationPeak: Bool = false
    private var notificationDecent: Bool = false
    private let standardOfPeak = 600.0
    var isPeak = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    // startUpdateTimer로 분리
    func startUpdateLocationData(){
//        startSpeedUpdateTimer()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // 최고의 정확도 대신 배터리 소모 상승
        // 위 옵션 종류 kCLLocationAccuracyBest, kCLLocationAccuracyNearestTenMeters(10m), kCLLocationAccuracyHundredMeters(100m) 등 순으로 정확도, 배터리 상승
        locationManager.distanceFilter = 100 //5m마다
//        locationManager.distanceFilter = kCLDistanceFilterNone  // 모든 움직임에 대해 업데이트를 받고 싶을 때
        locationManager.startUpdatingLocation()
    }
    
    func StopUpdateTimer(){
        stopSpeedUpdateTimer()
    }
    
    private func stopSpeedUpdateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func isNotificationPeak() -> Bool{
        if notificationPeak{
            notificationPeak = false
            return true
        }
        else{
            return false
        }
    }
    
    func isNotificationDecent() -> Bool{
        if notificationDecent{
            notificationDecent = false
            return true
        }
        else{
            return false
        }
    }

    // 위치가 바뀔 때 호출 됨
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if location.altitude > 0{
                self.currentAltitude = location.altitude
            }
            self.calculateAltitudeDifference()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription) : \(currentAltitude),\(currentAltitude)")
    }
    
    func appendCoreLocationLogs(isRecord: Bool){
        if isRecord {
            altitudeLogs.append(currentAltitude)
            speedLogs.append(currentSpeed)
        }
        else{
            //일시정지시 0값 넣기
            altitudeLogs.append(0.0)
            speedLogs.append(0.0)
        }
    }
    
    //TODO: 이거 등반 고도 나중에 함수 따로 빼야됨 -> log탐색 하는 것을 매번 불러오기 부담일 수 있어서 시작고도 저장해 놓고 최고고도 변경해가면서 등반고도값도 변경되게 만들어야 될 듯
    func calculateAltitudeDifference() {
        guard let firstValidValue = altitudeLogs.first(where: { $0 != 0 }) else {
            print("유효한 첫 번째 값이 없습니다.")
            return
        }

        guard let maxValue = altitudeLogs.max() else {
            print("최고 값을 찾을 수 없습니다.")
            return
        }
        let difference = maxValue - firstValidValue
        climbingAltitude = difference
    }
    
    func findNonZeroMin() -> Double? {
        let nonZeroValues = altitudeLogs.filter { $0 != 0 }
        return nonZeroValues.min()
    }
    
    func getSpeedAvg() -> Double {
        //0.5km/h이상의 값만 유효한 값으로 인식
        let nonZeroImpulseLogs = speedLogs.filter { $0 >= 0.5 }

        guard !nonZeroImpulseLogs.isEmpty else {
            return 0.0
        }
        
        let sum = nonZeroImpulseLogs.reduce(0, +)
        
        let average = sum / Double(nonZeroImpulseLogs.count)
        
        return average
    }
    
    deinit {
        stopSpeedUpdateTimer()
    }
}
