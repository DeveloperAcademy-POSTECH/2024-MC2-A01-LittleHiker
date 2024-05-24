//
//  CoreLocationManager.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/17/24.
//

import Foundation
import Combine
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

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //밑에 부분은 시작 버튼누르고 321 지나고 나서 실행하게 바꿔야됨
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // 최고의 정확도 대신 배터리 소모 상승
        // 위 옵션 종류 kCLLocationAccuracyBest, kCLLocationAccuracyNearestTenMeters(10m), kCLLocationAccuracyHundredMeters(100m) 등 순으로 정확도, 배터리 상승
        locationManager.distanceFilter = 10 //10m마다
//        locationManager.distanceFilter = kCLDistanceFilterNone  // 모든 움직임에 대해 업데이트를 받고 싶을 때
    }
    // 10초 동안 로케이션 변화 감지 못하면 속도 0으로 셋팅
    private func startSpeedUpdateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.updateSpeed()
        }
    }
    
    private func stopSpeedUpdateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateSpeed() {
        // GPS 업데이트가 없을 때 속도를 0으로 설정
        if let lastLocation = previousLocation {
            if Date().timeIntervalSince(lastLocation.timestamp) > 10 {
                self.currentSpeed = 0
            }
        } else {
            self.currentSpeed = 0
        }
    }
    

    // 위치가 바뀔 때 호출 됨
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if location.altitude > 0{
                self.currentAltitude = location.altitude
            }
            if location.speed == -1 {
                if speedLogs.isEmpty{
                    self.currentSpeed = 0
                } else {
                    self.currentSpeed = speedLogs.last!
                }
            }
            else {
                self.currentSpeed = location.speed * 3.6
            }
            
            // 총 이동 거리 계산
            if let previousLocation = self.previousLocation {
                let distance = location.distance(from: previousLocation)
                
                // 최소 거리 이하의 변화를 무시
                if distance > minimumDistance {
                    self.totalDistanceTraveled += distance / 1000 // 킬로미터 단위로 변환
                    self.previousLocation = location
                }
            } else {
                self.previousLocation = location
            }
            
            //임의 등반고도 구하기
            self.calculateAltitudeDifference()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription) : \(currentAltitude),\(currentAltitude)")
    }
    //append func 따로 만들고 충격량 로그도 만듦
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
        //필요 없어서 삭제
    }
    
    //이거 등반 고도 나중에 함수 따로 빼야됨 -> log탐색 하는 것을 매번 불러오기 부담일 수 있어서 시작고도 저장해 놓고 최고고도 변경해가면서 등반고도값도 변경되게 만들어야 될 듯
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
