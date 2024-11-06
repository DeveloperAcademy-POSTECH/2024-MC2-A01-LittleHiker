//
//  HikingViewModel+IOS.swift
//  LittleHiker
//
//  Created by 백록담 on 8/29/24.
//
import Foundation
import HealthKit

class HikingViewModel {
    let healthKitManager = HealthKitManager()
    let dataSource: DataSource = DataSource.shared // SwiftData + MVVM을 위해 필요한 변수
    
    /// Watch에서 받은 데이터를 ios에 저장한다
    @MainActor
    public func saveDataFromWatch(_ data: Data) {
        do {
            // watch에서 온 데이터
            let resultArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
            
            // watch에서 받은 데이터를 HikingRecord에 저장
            let hikingRecords = dataSource.fetchHikingRecords()
            if resultArray["data"] != nil { //summaryModel
                saveReceivedSummaryData(resultArray, hikingRecords, dataSource)
            }
            
            // watch에서 받은 로그데이터를 HikingRecord 내의 Log에 저장
            if resultArray["logs"] != nil { //summaryModel
                // TODO: - HikingLog 저장
                saveReceivedLogs(resultArray, hikingRecords, dataSource)
            }
            
            // TODO: - 헬스킷 조회
        } catch {
            print(error.localizedDescription)
        }
    }
}
    
    
    extension HikingViewModel {
        @MainActor
        func saveReceivedSummaryData(_ resultArray: [String: Any], _ hikingRecords: [HikingRecord], _ dataSource: DataSource) {
            if let data = resultArray["data"] as? [String: Any] {
                // 스위프트 데이터에 watch에서 온 데이터가 있으면
                if let hikingRecord = hikingRecords.first(where: {$0.id == data["id"] as? UUID}) {
                    hikingRecord.id = data["id"] as! UUID
                    
                    // TODO: - 더 간단하게 쓸 수 있을지 리팩토링
                    if let title = data["title"] as? String {
                        hikingRecord.title = title
                    }
                    if let startAltitude = data["startAltitude"] as? Int {
                        hikingRecord.startAltitude = startAltitude
                    }
                    if let peakAltitude = data["peakAltitude"] as? Int {
                        hikingRecord.peakAltitude = peakAltitude
                    }
                    if let endAltitude = data["endAltitude"] as? Int {
                        hikingRecord.endAltitude = endAltitude
                    }
                    if let maxAltitude = data["maxAltitude"] as? Int {
                        hikingRecord.peakAltitude = maxAltitude
                    }
                    if let startDate = data["startDate"] as? Date {
                        hikingRecord.startDateTime = startDate
                    }
                    if let endDate = data["endDate"] as? Date {
                        hikingRecord.endDateTime = endDate
                    }
                    if let duration = data["duration"] as? Int {
                        hikingRecord.duration = duration
                    }
                    if let ascendAvgSpeed = data["ascendAvgSpeed"] as? Int {
                        hikingRecord.ascendAvgSpeed = ascendAvgSpeed
                    }
                    if let descendAvgSpeed = data["descendAvgSpeed"] as? Int {
                        hikingRecord.descendAvgSpeed = descendAvgSpeed
                    }
                    if let heartRateAvg = data["heartRateAvg"] as? Int {
                        hikingRecord.avgHeartRate = heartRateAvg
                    }
                    if let heartRateMax = data["heartRateMax"] as? Int {
                        hikingRecord.maxHeartRate = heartRateMax
                    }
                    if let heartRateMin = data["heartRateMin"] as? Int {
                        hikingRecord.minHeartRate = heartRateMin
                    }
                    
                    dataSource.saveItem(hikingRecord)
                    
                } else {
                    let newHikingRecord = HikingRecord(
                        id: data["id"] as? UUID ?? UUID(),
                        title: "\(data["startDate"] as? String ?? "-")",
                        duration: data["duration"] as? Int ?? 0,
                        startDateTime: data["startDate"] as? Date ?? Date(),
                        endDateTime: data["endDate"] as? Date ?? Date(),
                        startAltitude: data["startAltitude"] as? Int ?? 0,
                        peakAltitude: data["peakAltitude"] as? Int ?? 0,
                        endAltitude: data["endAltitude"] as? Int ?? 0,
                        ascendAvgSpeed: data["ascendAvgSpeed"] as? Int ?? 0,
                        descendAvgSpeed: data["descendAvgSpeed"] as? Int ?? 0,
                        avgForce: data["avgForce"] as? Int ?? 0,
                        painRate: data["painRate"] as? Int ?? 0,
                        minHeartRate: data["minHeartRate"] as? Int ?? 0,
                        maxHeartRate: data["maxHeartRate"] as? Int ?? 0,
                        avgHeartRate: data["avgHeartRate"] as? Int ?? 0,
                        hikingLog: [:]
                    )
                    dataSource.saveItem(newHikingRecord)
                }
            }
        }
        
        @MainActor
        func saveReceivedLogs(_ resultArray: [String: Any], _ hikingRecords: [HikingRecord], _ dataSource: DataSource) {
            if let logs = resultArray["logs"] as? [String: Any] {
                if let hikingRecord = hikingRecords.first(where: {$0.id == logs["id"] as? UUID}) {
                    hikingRecord.hikingLog = logs["logs"] as? [String: String] ?? [:]
                    dataSource.saveItem(hikingRecord)
                } else {
                    let newHikingRecord = HikingRecord(
                        id: UUID(),
                        title: "-",
                        duration: 0,
                        startDateTime: Date(),
                        endDateTime: Date(),
                        startAltitude: 0,
                        peakAltitude: 0,
                        endAltitude: 0,
                        ascendAvgSpeed: 0,
                        descendAvgSpeed: 0,
                        avgForce: 0,
                        painRate: 0,
                        minHeartRate: 0,
                        maxHeartRate: 0,
                        avgHeartRate: 0,
                        hikingLog: logs["logs"] as? [String: String] ?? [:]
                    )
                    dataSource.saveItem(newHikingRecord)
                    
                }
            }
        }
        
        
    }
