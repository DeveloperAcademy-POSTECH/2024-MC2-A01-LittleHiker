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
//    case stop
    case hikingStop
    case descendingStop
    case peak
    case descending
    
    // 상태별 네이게이션바에 보여줄 텍스트
    var getData : String {
        switch self{
        case .ready :
            return "준비"
        case .hiking :
            return "등산중"
        case .hikingStop :
            return "일시정지"
        case .descendingStop :
            return "일시정지"
        case .peak :
            return "정상"
        case .descending :
            return "하산중"
            
        }
    }
}

class HikingViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {

    private var locationManager = CLLocationManager()
    private var previousLocation: CLLocation?
    private var totalDistance: Double = 0.0 // 총 이동한 거리 변수
    @Published var totalDistanceTraveled: Double = 0.0 // 총 이동 거리 확인용 임시 변수

    @Published var status: HikingStatus = .ready //앞으로 관리할 타입 enum으로 관리? ex)준비, 등산, 정지, 정산, 하산
    @Published var isDescent: Bool = true
    private var anchor: HKQueryAnchor?

    //manager 가져오기
    @Published var healthKitManager = HealthKitManager()
    @Published var coreLocationManager = CoreLocationManager()
    @Published var impulseManager = ImpulseManager()
    
    @Published var isPaused: Bool = false
    
    private var timer: Timer?
        
    override init() {
        super.init()
        updateEveryMinute()
    }
    
    func updateEveryMinute() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in

            guard let self = self else { return }
            
            self.coreLocationManager.altitudeLogs.append(self.coreLocationManager.currentAltitude)
            self.coreLocationManager.speedLogs.append(self.coreLocationManager.currentSpeed)
            
            //HealthKit append 수정
            self.healthKitManager
                .appendHealthKitLogs(self.healthKitManager.currentHeartRate, distance: self.healthKitManager.currentDistanceWalkingRunning)
            
            self.impulseManager.calculateImpulseRate(
                altitudeLogs: self.coreLocationManager.altitudeLogs,
                currentSpeed: self.coreLocationManager.currentSpeed
            )
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // 버튼별로 타이머 기능을 조절하도록 만들었다. by.벨
    
   func pause() {
       if status == .hiking {
//           등산중인지하산중인지 나타내는 변수
//           isDescent = false
           status = .hikingStop

       } else if status == .descending {
//           isDescent = true
           status = .descendingStop
       }
//       status = .hikingStop
       
       isPaused = true
       timer?.invalidate()
   }
   
   func restart() {
       if status == .hikingStop {
           status = .hiking
       }
       else if  status == .descendingStop {
           status = .descending
       }
       isPaused = false
       updateEveryMinute()
   }
   
   func reachPeak() {
       status = .peak
       isPaused = true
   }
   
   func startDescending() {
       status = .descending
       isPaused = false
       updateEveryMinute()
   }
   
   func stop() {
       isPaused = true
       status = .descendingStop
       // TODO: 전체종료 기능 넣기
       timer?.invalidate()
       // TODO: 기록을 SummaryView 로 넘긴다. by. 벨
   }
    
}
