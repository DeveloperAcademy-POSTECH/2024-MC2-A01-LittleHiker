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
    case complete
    
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
        case .complete :
            return "완료"
        }
    }
}

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

    private var locationManager = CLLocationManager()
    private var previousLocation: CLLocation?
    private var totalDistance: Double = 0.0 // 총 이동한 거리 변수
    @Published var totalDistanceTraveled: Double = 0.0 // 총 이동 거리 확인용 임시 변수

    @Published var status: HikingStatus = .ready //앞으로 관리할 타입 enum으로 관리? ex)준비, 등산, 정지, 정산, 하산
    @Published var isDescent: Bool = false
    private var anchor: HKQueryAnchor?

    //manager 가져오기
    @Published var healthKitManager = HealthKitManager()
    @Published var coreLocationManager = CoreLocationManager()
    @Published var impulseManager = ImpulseManager()
    @Published var summaryModel = SummaryModel()
    
    @Published var isPaused: Bool = false
    
    @Published var isShowingModal = false
    
    private var timer: Timer?
    //테스트용
    var viewModelWatch = ViewModelWatch()
    var testCodeTimer: Timer?
    var timestampLog: [String] = []

    override init() {
        super.init()
        updateEveryMinute()
    }
    
    func updateEveryMinute() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in

            guard let self = self else { return }
            
            //하이킹 모드 아닐 때 로그 0으로 저장 추가
            self.healthKitManager.appendHealthKitLogs(isRecord: self.isRecord())
            self.coreLocationManager.appendCoreLocationLogs(isRecord: self.isRecord()) //순서변경
            self.impulseManager.calculateAndAppendRecentImpulse(
                altitudeLogs: self.coreLocationManager.altitudeLogs,
                currentSpeed: self.coreLocationManager.currentSpeed
            )
            self.impulseManager.appendToLogs(isRecord: isRecord())
            //testcode 기준속도 변경
            self.impulseManager.diagonalVelocityCriterion = viewModelWatch.impulseRate
            //timestamptest
            self.timestampLog.append(getCurrentTimestamp())
            //다람상식 푸쉬 로직
            self.impulseManager.sendTipsIfConditionMet()
            
            
            
        }
        //테스트용 스케쥴러
        testCodeTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.testCode()
        }
    }
    // 기록상태 확인 코드 추가
    func isRecord() -> Bool {
        return status == .descending || status == .hiking ? true : false
    }
    
    //타임스탬프 만드는 함수
    func getCurrentTimestamp() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestampString = dateFormatter.string(from: currentDate)
        return timestampString
    }
    
    func testCode(){
        //10초마다 하나씩 보내기
//        self.viewModelWatch.session.sendMessage(["message" : "고도 : \(Int(self.coreLocationManager.currentAltitude)), "], replyHandler: nil) { error in
//        }
//        self.viewModelWatch.session.sendMessage(["message" : "속도 : \(String(format: "%.2f", self.coreLocationManager.currentSpeed)), "], replyHandler: nil) { error in
//        }
//        self.viewModelWatch.session.sendMessage(["message" : "기준 속도 : \(self.impulseManager.diagonalVelocityCriterion), "], replyHandler: nil) { error in
//        }
//        self.viewModelWatch.session.sendMessage(["message" : "기준 충격량 : \(String(format: "%.2f", self.impulseManager.impulseCriterion)), "], replyHandler: nil) { error in
//        }
//        self.viewModelWatch.session.sendMessage(["message" : "충격량 : \(String(format: "%.2f", self.impulseManager.impulseLogs.last ?? 0.0)), "], replyHandler: nil) { error in
//        }
//        self.viewModelWatch.session.sendMessage(["message" : "충격량 비율 : \(String(format: "%.2f", self.impulseManager.impulseRatio)), "], replyHandler: nil) { error in
//        }
//        self.viewModelWatch.session.sendMessage(["message" : "\n"], replyHandler: nil) { error in
//        }
//        self.impulseManager.diagonalVelocityCriterion = self.viewModelWatch.impulseRate
        //3분마다 log 업데이트 보내기 -> 임의 기준속도 로그 생성
        let combinedString = (0..<min(self.timestampLog.count ,self.coreLocationManager.altitudeLogs.count, self.coreLocationManager.speedLogs.count, self.impulseManager.impulseLogs.count, self.impulseManager.diagonalVelocityCriterionLogs.count)).map { index in
            "\(self.timestampLog[index]) : 고도 : \(Int(self.coreLocationManager.altitudeLogs[index])),속도 : \(String(format: "%.2f",self.coreLocationManager.speedLogs[index])), 기준 속도 : \(String(format: "%.2f",self.impulseManager.diagonalVelocityCriterionLogs[index])), 기준 충격량 : \(String(format: "%.2f",self.impulseManager.impulseCriterionLogs[index])), 충격량 : \(String(format: "%.2f",self.impulseManager.impulseLogs[index]))"
        }.joined(separator: "\n")
        self.viewModelWatch.session.sendMessage(["message" : combinedString], replyHandler: nil) { error in
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    //하이킹 종료
    func endHiking(){
        healthKitManager.fetchHeartRateStatistics{ (averageHeartRate, minHeartRate, maxHeartRate, error) in
            if let averageHeartRate = averageHeartRate, let minHeartRate = minHeartRate, let maxHeartRate = maxHeartRate {
                self.summaryModel.heartRateAvg = Int(averageHeartRate)
                self.summaryModel.maxheartRate = Int(maxHeartRate)
                self.summaryModel.minheartRate = Int(minHeartRate)
            }else {
                print("심박수 데이터를 가져오는데 실패했습니다: \(String(describing: error))")
            }
        }
        //nil값 보호
        summaryModel.totalAltitude = Int(coreLocationManager.climbingAltitude)
        if let altitudeLogs = coreLocationManager.altitudeLogs.max(){
            summaryModel.maxAltitude = Int(altitudeLogs)
        } else {
            summaryModel.maxAltitude = 0
        }
        if let minAltitude = coreLocationManager.findNonZeroMin(){
            summaryModel.minAltitude = Int(minAltitude)
        } else {
            summaryModel.minAltitude = 0
        }
        summaryModel.totalDistance = healthKitManager.currentDistanceWalkingRunning
        summaryModel.speedAvg = coreLocationManager.getSpeedAvg()
        summaryModel.impulseAvg = impulseManager.getImpulseAvg()
        
        if let minImpulse = impulseManager.findNonZeroMin(){
            summaryModel.minImpulse = Int(minImpulse)
        } else {
            summaryModel.minImpulse = 0
        }
        if let maxImpulse = impulseManager.impulseLogs.max(){
            summaryModel.maxImpulse = Int(maxImpulse)
        } else {
            summaryModel.maxImpulse = 0
        }
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
       timer = nil
       //test용
       testCodeTimer?.invalidate()
       testCodeTimer = nil
       // TODO: 기록을 SummaryView 로 넘긴다. by. 벨
   }
    
}
