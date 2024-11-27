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
    @Published var status: HikingStatus = .ready //앞으로 관리할 타입 enum으로 관리? ex)준비, 등산, 정지, 정산, 하산
    //    @Published var isDescent: Bool = true
    @Published var isDescent: Bool = false
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
            self.coreLocationManager.appendCoreLocationLogs(isRecord: self.isRecord())
            
            //TODO: 타임스케줄러를 시작버튼 누를 때 돌아가도록 바꾸기
            
            if status == .descending{
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
        if status == .hiking {
            if coreLocationManager.isNotificationPeak() {
                print("정상입니까 알람 필요")
            }
        }
        if status == .peak {
            coreLocationManager.isPeak = true
            if coreLocationManager.isNotificationDecent() {
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
                    self.summaryModel.avgHeartRate = Int(averageHeartRate)
                    self.summaryModel.maxHeartRate = Int(maxHeartRate)
                    self.summaryModel.minHeartRate = Int(minHeartRate)
                } else {
                    print("심박수 데이터를 가져오는데 실패했습니다: \(String(describing: error))")
                }
                
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
                
                self.summaryModel.totalDistance = self.healthKitManager.currentDistanceWalkingRunning // 헬스킷에서 총 거리 가져오기
                self.summaryModel.avgSpeed = self.healthKitManager.getAvgSpeed() //헬스킷에서 평균 속도 가져오기
                self.summaryModel.avgImpulse = self.impulseManager.getAvgImpulse()
                
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
                
                //uuidString이 호출때마다 uuid를 생성해서 보내는 데이터 uuid 통일이 안되서 한번만 생성 후 사용
                let uuid = self.healthKitManager.workoutSession?.currentActivity.uuid.uuidString ?? ""
                if uuid != "" {
                    //산행으로 만들어진 SummaryData
                    let customComplementaryHikingData = self.createCustomComplementaryHikingData(
                        uuid: uuid,
                        summaryModel: self.summaryModel)
                    
                    //산행으로 만들어진 시간과 충격량
                    let logsWithTimeStamps = self.createLogWithTimeStamps(
                        uuid: uuid,
                        impulseRateLogs: self.impulseManager.impulseLogs,
                        timeStampLogs: self.timestampLog)
                    
                    
                    //MARK: 파일 생성
                    let customComplementaryHikingDataFileURL = self.makeFile( self.encodeToJson(customComplementaryHikingData), "SummaryModel")
                    
                    //                let logsWithTimeStampsFileURL =  self.makeFile(self.encodeToJson(["id" : logsWithTimeStamps.id, "logs": self.encodeToJson(logsWithTimeStamps.logs)]), "ImpulseLogs")
                    let logsWithTimeStampsFileURL =  self.makeFile(self.encodeToJson(logsWithTimeStamps), "ImpulseLogs")
                    
                    //TODO: 순차전송
                    self.watchToIOSConnector.transferFile(customComplementaryHikingDataFileURL!, nil)
                    self.watchToIOSConnector.transferFile(logsWithTimeStampsFileURL!, nil)
                    
                    // MARK: SwiftData로 저장
                    self.dataSource.saveItem(customComplementaryHikingData)
                    self.dataSource.saveItem(logsWithTimeStamps)
                }
            }
        }
    }
    
    func pause() {
        if status == .hiking {
            status = .hikingPause
        } else if status == .descending {
            status = .descendingPause
        }
        healthKitManager.pauseHikingWorkout()
        timer?.invalidate()
    }
    
    func restart() {
        if status == .hikingPause {
            status = .hiking
        } else if  status == .descendingPause {
            status = .descending
        }
        healthKitManager.resumeHikingWorkout()
        updateEverySecond()
    }
    
    func startDescending() {
        status = .descending
        updateEverySecond()
    }
    
    func stop() {
        status = .descendingPause
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension HikingViewModel {
    //TODO: HikingViewModel 뿐 아니라 다른데서도 쓰이지 않을까? 함수 위치 변경 고려해보장
    func encodeToJson<T: Encodable>(_ value: T) -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // for pretty-printed JSON
        do {
            let jsonData = try encoder.encode(value)
            return jsonData
            //            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            print("Error encoding data: \(error)")
            return Data()
        }
    }
    
    func createCustomComplementaryHikingData(uuid: String, summaryModel: SummaryModel) -> CustomComplementaryHikingData {
        let customComplementaryHikingData = CustomComplementaryHikingData()
        customComplementaryHikingData.id = uuid
        customComplementaryHikingData.data = self.summaryModel
        return customComplementaryHikingData
    }
    
    func mapLogsWithTimeStamps(_ logs: [Double], _ timeStamps: [String]) -> [String: String] {
        
        var result: [String: String] = [:]
        
        for (i, log) in logs.enumerated() {
            result[timeStamps[i]] = String(log)
        }
        
        return result
    }
    
    func createLogWithTimeStamps(uuid: String, impulseRateLogs: [Double],
                                 timeStampLogs: [String]) -> LogsWithTimeStamps{
        
        let logsWithTimeStamps = LogsWithTimeStamps()
        
        logsWithTimeStamps.id = uuid
        logsWithTimeStamps.logs = mapLogsWithTimeStamps(impulseRateLogs, timeStampLogs)
        
        return logsWithTimeStamps
    }
    
    func makeFile(_ jsonData : Data, _ fileName: String) -> URL? {
        let fileManager = FileManager.default
        let timeManager = TimeManager()
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("\(fileName)_\(timeManager.formatToYmdHis()).json")
            do {
                try jsonData.write(to: fileURL)
                //                try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
                return fileURL
            } catch {
                print("Failed to write file: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
