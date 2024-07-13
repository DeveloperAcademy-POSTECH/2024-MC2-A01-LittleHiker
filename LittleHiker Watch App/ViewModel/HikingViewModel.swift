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


class HikingViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    //TODO: 0708 Watch데이터 ios로 보내기 위해 여기 씀 / ViewModel 무거워서 분리해야할수도
    let dataSource: DataSource = DataSource.shared // SwiftData + MVVM을 위해 필요한 변수
    var watchToIOSConnector = WatchToIOSConnector()
    
    static let shared = HikingViewModel()
    private var locationManager = CLLocationManager()
    private var previousLocation: CLLocation?
    private var totalDistance: Double = 0.0 // 총 이동한 거리 변수
    
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
//        self.dataSource = DataSource.shared
    }
    
    func initializeManager() {
        healthKitManager = HealthKitManager()
        coreLocationManager = CoreLocationManager()
        impulseManager = ImpulseManager()
        summaryModel = SummaryModel()
    }
    
    func startHiking() {
        status = .hiking
        isDescent = false
        updateEverySecond()
        healthKitManager.startHikingWorkout()
        coreLocationManager.startUpdateLocationData()
    }
    
    func isRecord() -> Bool {
        return status == .descending || status == .hiking ? true : false
    }
    
    func updateEverySecond() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            
            guard let self = self else { return }
            
            //하이킹 모드 아닐 때 로그 0으로 저장 추가
            self.healthKitManager.appendHealthKitLogs(isRecord: self.isRecord())
            
            //TODO: 타임스케줄러를 시작버튼 누를 때 돌아가도록 바꾸기
            
            if status == .descending{
                //TODO: impulseManager안에 다 호출하는 함수 만들기
                self.impulseManager.calculateImpulse(
                    altitudeLogs: self.coreLocationManager.altitudeLogs,
                    currentSpeed: self.healthKitManager.currentSpeed
                )
                impulseManager.processImpulseData(isRecord: isRecord())
                
                //TODO: LocalNotifications안에 다 호출하는 함수 만들기
                LocalNotifications.shared.decreaseTipsBlockCount()
                LocalNotifications.shared.decreaseWarningBlockCount()
                
                // TODO: appendToLogs에서 currentTimestamp값을 key로 넣은 Dictionary로 만들면 좋을 것 같음
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
            self.summaryModel.totalDistance = self.healthKitManager.currentDistanceWalkingRunning // 헬스킷에서 총 거리 가져오기
            self.summaryModel.speedAvg = self.healthKitManager.getSpeedAvg() //헬스킷에서 평균 속도 가져오기
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
            
            let customData: [String: String] = self.convertDataLogsToJSON(
                summaryModel : self.summaryModel,
                myWorkoutSession : self.healthKitManager.workoutSession,
                impulseRateLogs : self.impulseManager.impulseLogs,
                timeStampLogs : self.timestampLog
            )
            
            //TODO: swiftData로 저장하기
            let customComplementaryHikingData = self.createCustomComplementaryHikingData(
                myWorkoutSession: self.healthKitManager.workoutSession,
                summaryModel: self.summaryModel)
//             modelContext.insert(customComplementaryHikingData)
            self.dataSource.appendCustomComplementaryHikingData(item: customComplementaryHikingData)
            
            let logsWithTimeStamps = self.createLogWithTimeStamps(
                myWorkoutSession: self.healthKitManager.workoutSession,
                impulseRateLogs: self.impulseManager.impulseLogs,
                timeStampLogs: self.timestampLog)
            // modelContext.insert(logsWithTimeStamps)
            self.dataSource.appendLogsWithTimeStamps(item: logsWithTimeStamps)
            
            
            //TODO: watch에서 iOS로 데이터 넘기기
        }
        
        //end버튼 누르면 watch에서 ios로 데이터 넘기기
        //        watchToIOSConnector.sendDataToIOS(impulseManager.impulseLogs, timestampLog)
    }
    

    func pause() {
        if status == .hiking {
            status = .hikingStop
        } else if status == .descending {
            status = .descendingStop
        }
        isPaused = true
        healthKitManager.pauseHikingWorkout()
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
        healthKitManager.resumeHikingWorkout()
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
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        timer?.invalidate()
    }
    
}


extension HikingViewModel {
    func encodeToJson(_ summary: SummaryModel) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // for pretty-printed JSON
        do {
            let jsonData = try encoder.encode(summary)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding data: \(error)")
            return nil
        }
    }
  
    
    func createCustomComplementaryHikingData(myWorkoutSession: HKWorkoutSession?, 
                                             summaryModel: SummaryModel) -> CustomComplementaryHikingData {
        
        
        var customComplementaryHikingData = CustomComplementaryHikingData()
    
        guard let id: String = myWorkoutSession?.currentActivity.uuid.uuidString else {
            return customComplementaryHikingData
        }
        
        customComplementaryHikingData.id = id
        customComplementaryHikingData.data = self.summaryModel
        return customComplementaryHikingData
    }
    
    func mapLogsWithTimeStamps(_ logs: [Double], _ timeStamps: [String]) -> [String: String] {
        
        var result: [String: String] = [:]
        
        for (i, log) in logs.enumerated() {
            result[timeStamps[i]] = String(logs[i])
        }
        
        return result
    }
    
    
    func createLogWithTimeStamps(myWorkoutSession: HKWorkoutSession?,
                                 impulseRateLogs: [Double],
                                 timeStampLogs: [String]) -> LogsWithTimeStamps{
        
        var logsWithTimeStamps = LogsWithTimeStamps()
        
        guard let id: String = myWorkoutSession?.currentActivity.uuid.uuidString else {
            return logsWithTimeStamps
        }
        
        logsWithTimeStamps.id = id
        logsWithTimeStamps.logs = mapLogsWithTimeStamps(impulseRateLogs, timeStampLogs)
        
        return logsWithTimeStamps
    }
    
    
    func convertDataLogsToJSON(summaryModel: SummaryModel, myWorkoutSession: HKWorkoutSession?, impulseRateLogs: [Double], timeStampLogs: [String]) -> [String: String]{
        var result: [String: String] = ["ID":"-"]
        guard let identifier: String = myWorkoutSession?.currentActivity.uuid.uuidString else {return result}
        result["ID"] = identifier
        result["Body"] = self.encodeToJson(summaryModel) ?? ""
        return result
    }
    
}
