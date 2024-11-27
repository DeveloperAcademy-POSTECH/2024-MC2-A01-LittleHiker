//
//  HikingViewModel+IOS.swift
//  LittleHiker
//
//  Created by 백록담 on 8/29/24.
//
import Foundation
import HealthKit

class HikingViewModel: ObservableObject {
    let healthKitManager = HealthKitManager()
    let dataSource: DataSource = DataSource.shared // SwiftData + MVVM을 위해 필요한 변수
    static let shared = HikingViewModel()
    
    /// Watch에서 받은 데이터를 ios에 저장한다
    @MainActor
    public func saveDataFromWatch(_ data: Data) {
        do {
            // watch에서 온 데이터
            let resultArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
            
            // watch에서 받은 데이터를 HikingRecord에 저장
            var hikingRecords = dataSource.fetchHikingRecords()
            
            
            Task{
                if resultArray["data"] != nil { //summaryModel
                    await saveReceivedSummaryData(resultArray, hikingRecords, dataSource)
                }
                hikingRecords = dataSource.fetchHikingRecords()
                // watch에서 받은 로그데이터를 HikingRecord 내의 Log에 저장
                if resultArray["logs"] != nil { //summaryModel
                    // TODO: - HikingLog 저장
                    await saveReceivedLogs(resultArray, hikingRecords, dataSource)
                }
            }
            // TODO: - 헬스킷 조회
        } catch {
            print(error.localizedDescription)
        }
    }
}
    
extension HikingViewModel {
    @MainActor
    func saveReceivedSummaryData (
        _ resultArray: [String: Any],
        _ hikingRecords: [HikingRecord],
        _ dataSource: DataSource
    ) async {
        if let data = resultArray["data"] as? [String: Any] {
            // 스위프트 데이터에 watch에서 온 데이터가 있으면
            if let hikingRecord = hikingRecords.first(
                where: {$0.id == UUID(uuidString: resultArray["id"] as? String ?? "")
                }) {
                hikingRecord.id = resultArray["id"] as! UUID
                    
                // TODO: - 더 간단하게 쓸 수 있을지 리팩토링
                if let title = data["title"] as? String {
                    hikingRecord.title = title
                }
                if let duration = data["duration"] as? Int {
                    hikingRecord.duration = duration
                }
                if let startDate = data["startDate"] as? Date {
                    hikingRecord.startDateTime = startDate
                }
                if let endDate = data["endDate"] as? Date {
                    hikingRecord.endDateTime = endDate
                }
                if let minHeartRate = data["minHeartRate"] as? Int {
                    hikingRecord.minHeartRate = minHeartRate
                }
                if let maxHeartRate = data["maxHeartRate"] as? Int {
                    hikingRecord.maxHeartRate = maxHeartRate
                }
                if let avgHeartRate = data["avgHeartRate"] as? Int {
                    hikingRecord.avgHeartRate = avgHeartRate
                }
                if let startAltitude = data["minAltitude"] as? Int {
                    hikingRecord.startAltitude = startAltitude
                }
                if let peakAltitude = data["maxAltitude"] as? Int {
                    hikingRecord.peakAltitude = peakAltitude
                }
                if let endAltitude = data["minAltitude"] as? Int {
                    hikingRecord.endAltitude = endAltitude
                }
                if let ascendAvgSpeed = data["ascendAvgSpeed"] as? Int {
                    hikingRecord.ascendAvgSpeed = ascendAvgSpeed
                }
                if let descendAvgSpeed = data["descendAvgSpeed"] as? Int {
                    hikingRecord.descendAvgSpeed = descendAvgSpeed
                }
                if let avgSpeed = data["avgSpeed"] as? Double {
                    hikingRecord.avgSpeed = avgSpeed
                }
                if let avgImpulse = data["avgImpulse"] as? Double {
                    hikingRecord.avgImpulse = avgImpulse
                }
                

                dataSource.saveItem(hikingRecord)
                    
            } else {
                let newHikingRecord = HikingRecord(
                    id: UUID(uuidString: resultArray["id"] as! String) ?? UUID(),
                    title: "\(data["startDate"] as? String ?? "-")",
                    duration: data["duration"] as? Int ?? 0,
                    startDateTime: data["startDate"] as? Date ?? Date(),
                    endDateTime: data["endDate"] as? Date ?? Date(),
                    minHeartRate: data["minHeartRate"] as? Int ?? 0,
                    maxHeartRate: data["maxHeartRate"] as? Int ?? 0,
                    avgHeartRate: data["heartRateAvg"] as? Int ?? 0,
                    startAltitude: data["minAltitude"] as? Int ?? 0,
                    peakAltitude: data["maxAltitude"] as? Int ?? 0,
                    endAltitude: data["minAltitude"] as? Int ?? 0,
                    ascendAvgSpeed: data["ascendAvgSpeed"] as? Int ?? 0,
                    descendAvgSpeed: data["descendAvgSpeed"] as? Int ?? 0,
                    avgSpeed: data["avgSpeed"] as? Double ?? 0.0,
                    avgImpulse: data["avgImpulse"] as? Double ?? 0.0,
                    hikingLog: [:])
                dataSource.saveItem(newHikingRecord)
            }
        }
    }
        
    @MainActor
    func saveReceivedLogs  (
        _ resultArray: [String: Any],
        _ hikingRecords: [HikingRecord],
        _ dataSource: DataSource
    ) async {
        if let logs = resultArray["logs"] as? [String: Any] {
            if let hikingRecord = hikingRecords.first(
                where: {$0.id == UUID(uuidString: resultArray["id"] as? String ?? "")
                }) {
                hikingRecord.hikingLog = logs["logs"] as? [String: String] ?? [:]
                dataSource.saveItem(hikingRecord)
            } else {
                let newHikingRecord =
                HikingRecord(
                    id: UUID(uuidString: resultArray["id"] as! String) ?? UUID(),
                    title: "-",
                    duration: 0,
                    startDateTime: Date(),
                    endDateTime: Date(),
                    minHeartRate: 0,
                    maxHeartRate: 0,
                    avgHeartRate: 0,
                    startAltitude: 0,
                    peakAltitude: 0,
                    endAltitude: 0,
                    ascendAvgSpeed: 0,
                    descendAvgSpeed: 0,
                    avgSpeed: 0.0,
                    avgImpulse: 0.0,
                    hikingLog: logs["logs"] as? [String: String] ?? [:]
                )
                dataSource.saveItem(newHikingRecord)
                    
            }
        }
    }
        
        
}
