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


struct SummaryModel{
    var minImpulse = 0
    var maxImpulse = 0
    var heartRateAvg = 0
    var minheartRate = 0
    var maxheartRate = 0
    var totalAltitude = 0
    var minAltitude = 0
    var maxAltitude = 0
    var totalDistance = 0.0
    var speedAvg = 0.0 //평균 페이스
    var impulseAvg = 0.0 //평균 충격량
    
}

class HikingViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let shared = HikingViewModel()
    private var locationManager = CLLocationManager()
    private var previousLocation: CLLocation?
    private var totalDistance: Double = 0.0 // 총 이동한 거리 변수
    @Published var totalDistanceTraveled: Double = 0.0 // 총 이동 거리 확인용 임시 변수
    
    @Published var status: HikingStatus = .ready //앞으로 관리할 타입 enum으로 관리? ex)준비, 등산, 정지, 정산, 하산
    //    @Published var isDescent: Bool = true
    @Published var isDescent: Bool = false
    @Published var isPaused: Bool = false
    @Published var isShowingModal = false
    
    //manager 가져오기
    @Published var healthKitManager = HealthKitManager()
    @Published var coreLocationManager = CoreLocationManager()
    @Published var impulseManager =  ImpulseManager()
    @Published var summaryModel = SummaryModel()
    
    private var timer: Timer?
    var timestampLog: [String] = []
    
    private override init() {
        super.init()
        updateEverySecond()
    }
    
    // 기록상태 확인 코드 추가
    func isRecord() -> Bool {
        return status == .descending || status == .hiking ? true : false
        
    }
    
    func updateEverySecond() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            
            guard let self = self else { return }
            
            //하이킹 모드 아닐 때 로그 0으로 저장 추가
            self.healthKitManager.appendHealthKitLogs(isRecord: self.isRecord())
            self.coreLocationManager.appendCoreLocationLogs(isRecord: self.isRecord()) //순서변경
            
            //TODO: 타임스케줄러를 시작버튼 누를 때 돌아가도록 바꾸기
            
            if status == .descending{
                //TODO: impulseManager안에 다 호출하는 함수 만들기
                self.impulseManager.calculateImpulse(
                    altitudeLogs: self.coreLocationManager.altitudeLogs,
                    currentSpeed: self.healthKitManager.currentSpeed
                )
                self.impulseManager.updateMeanOfLastTenImpulseLogs()
                self.impulseManager.appendToLogs(isRecord: isRecord())
                self.impulseManager.updateRedZoneCount()
                self.impulseManager.sendWarningIfConditionMet()
                self.impulseManager.sendTipsIfConditionMet()
                
                //TODO: LocalNotifications안에 다 호출하는 함수 만들기
                LocalNotifications.shared.decreaseTipsBlockCount()
                LocalNotifications.shared.decreaseWarningBlockCount()
                
                self.timestampLog.append(getCurrentTimestamp())
            }
            
            //TODO: 정상, 하산여부 체크
            self.checkNotification()
        }
    }
    
    func checkNotification(){
        if status == .hiking{
            if coreLocationManager.isNotificationPeak(){
                print("정상입니까 알람 필요")
            }
        }
        if status == .peak{
            coreLocationManager.isPeak = true
            if coreLocationManager.isNotificationDecent(){
                print("하산입니까 알람 필요")
            }
        }
    }
    
    //타임스탬프 만드는 함수
    func getCurrentTimestamp() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestampString = dateFormatter.string(from: currentDate)
        return timestampString
    }
    
    //하이킹 종료
    func endHiking() {
        self.healthKitManager.fetchHeartRateStatistics { (averageHeartRate, minHeartRate, maxHeartRate, error) in
            DispatchQueue.main.async {
                if let averageHeartRate = averageHeartRate, let minHeartRate = minHeartRate, let maxHeartRate = maxHeartRate {
                    self.summaryModel.heartRateAvg = Int(averageHeartRate)
                    self.summaryModel.maxheartRate = Int(maxHeartRate)
                    self.summaryModel.minheartRate = Int(minHeartRate)
                } else {
                    print("심박수 데이터를 가져오는데 실패했습니다: \(String(describing: error))")
                }
            }
        }
        
        DispatchQueue.main.async {
            // nil 값 보호
            self.summaryModel.totalAltitude = Int(self.coreLocationManager.climbingAltitude)
            
            if let altitudeLogs = self.coreLocationManager.altitudeLogs.max() {
                self.summaryModel.maxAltitude = Int(altitudeLogs)
            } else {
                self.summaryModel.maxAltitude = 0
            }
            
            if let minAltitude = self.coreLocationManager.findNonZeroMin() {
                self.summaryModel.minAltitude = Int(minAltitude)
            } else {
                self.summaryModel.minAltitude = 0
            }
            
            //            self.summaryModel.totalDistance = self.healthKitManager.currentDistanceWalkingRunning //기존 총거리
            self.summaryModel.totalDistance = self.coreLocationManager.totalDistanceTraveled // 코어 로케이션으로 총거리 받기
            self.summaryModel.speedAvg = self.coreLocationManager.getSpeedAvg()
            self.summaryModel.impulseAvg = self.impulseManager.getImpulseAvg()
            
            if let minImpulse = self.impulseManager.findNonZeroMin() {
                self.summaryModel.minImpulse = Int(minImpulse)
            } else {
                self.summaryModel.minImpulse = 0
            }
            
            if let maxImpulse = self.impulseManager.impulseLogs.max() {
                self.summaryModel.maxImpulse = Int(maxImpulse)
            } else {
                self.summaryModel.maxImpulse = 0
            }
        }
    }
    
    
    func pause() {
        if status == .hiking {
            status = .hikingStop
        } else if status == .descending {
            status = .descendingStop
        }
        isPaused = true
        //TODO: HikingMode 멈춰야겠다. 하이킹 워크아웃 멈춰야 함.헬스킷 매니저 안에 하이킹 워크아웃 세션을 관리하는 게 있는데, 그것 또한 기록하는 걸 멈춰야 함
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
        updateEverySecond()
    }
    
    func reachPeak() {
        status = .peak
        isPaused = true
    }
    
    func startDescending() {
        status = .descending
        isPaused = false
        updateEverySecond()
    }
    
    func stop() {
        isPaused = true
        status = .descendingStop
        // TODO: 전체종료 기능 넣기
        // 하이킹 워크아웃 멈춰야 함. 헬스킷 매니저 안에 하이킹 워크아웃 세션을 관리하는 게 있는데, 그것 또한 기록하는 걸 멈춰야 함
        timer?.invalidate()
        timer = nil
        
        coreLocationManager.StopUpdateTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
}
