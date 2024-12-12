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
                // TODO: - 더 간단하게 쓸 수 있을지 리팩토링
                if let title = data["title"] as? String {
                    hikingRecord.title = title
                }
                
                if let duration = data["duration"] as? Double {
                    hikingRecord.duration = duration
                }
                
                if let peakDateTime = data["peakDateTime"] as? String {
                    hikingRecord.peakDateTime = ISO8601DateFormatter().date(from: peakDateTime)
                }
                
                if let ascendingDuration = data["ascendingDuration"] as? String {
                    hikingRecord.ascendingDuration = ascendingDuration
                }
                
                if let descendingDuration = data["descendingDuration"] as? String {
                    hikingRecord.descendingDuration = descendingDuration
                }
                
                //healthKit에서 조회
                if let startDateTime = data["startDate"] as? String {
                    hikingRecord.startDateTime = ISO8601DateFormatter().date(from: startDateTime)
                }
                //healthKit에서 조회
                if let endDateTime = data["endDate"] as? String {
                    hikingRecord.endDateTime = ISO8601DateFormatter().date(from: endDateTime)
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
                
                // 헬스킷에서 조회
//                if let startAltitude = data["minAltitude"] as? Int {
//                    hikingRecord.startAltitude = startAltitude
//                }
                // watch에서 전송받음
                if let peakAltitude = data["peakAltitude"] as? Int {
                    hikingRecord.peakAltitude = peakAltitude
                }
                // 헬스킷에서 조회
//                if let endAltitude = data["minAltitude"] as? Int {
//                    hikingRecord.endAltitude = endAltitude
//                }
                // watch에서 전송받음
                if let minAltitude = data["minAltitude"] as? Int {
                    hikingRecord.minAltitude = minAltitude
                }
                // watch에서 전송받음
                if let maxAltitude = data["maxAltitude"] as? Int {
                    hikingRecord.maxAltitude = maxAltitude
                }
                if let totalAltitude = data["totalAltitude"] as? Int {
                    hikingRecord.totalAltitude = totalAltitude
                }
                
                if let totalDistance = data["totalDistance"] as? Double {
                    hikingRecord.totalDistance = totalDistance
                }
                
                // 헬스킷에 없어서 watch에서 전송받아야 함 (현재 전송 로직 없음)
                if let ascendAvgSpeed = data["ascendAvgSpeed"] as? Int {
                    hikingRecord.ascendAvgSpeed = ascendAvgSpeed
                }
                
                // 헬스킷에 없어서 watch에서 전송받아야 함 (현재 전송 로직 없음)
                if let descendAvgSpeed = data["descendAvgSpeed"] as? Int {
                    hikingRecord.descendAvgSpeed = descendAvgSpeed
                }
                
                // watch에서 전송받음
                if let avgSpeed = data["avgSpeed"] as? Double {
                    hikingRecord.avgSpeed = avgSpeed
                }
                
                if let avgImpulse = data["avgImpulse"] as? Double {
                    hikingRecord.avgImpulse = avgImpulse
                }
                
                //로그는 따로 관리
                dataSource.saveItem(hikingRecord)
            } else {
                let newHikingRecord = HikingRecord(
                    id: UUID(uuidString: resultArray["id"] as? String ?? "") ?? UUID(),
                    title: "\(data["startDate"] as? String ?? "-")",
                    duration: data["duration"] as? Double ?? 0.0,
                    startDateTime: data["startDate"] as? Date,
                    peakDateTime: ISO8601DateFormatter().date(from: data["peakDateTime"] as? String ?? "1970-01-01T00:00:00Z"),
                    endDateTime: data["endDate"] as? Date,
                    ascendingDuration: data["ascendingDuration"] as? String,
                    descendingDuration: data["descendingDuration"] as? String,
                    minHeartRate: data["minHeartRate"] as? Int ?? 0,
                    maxHeartRate: data["maxHeartRate"] as? Int ?? 0,
                    avgHeartRate: data["avgHeartRate"] as? Int ?? 0,
                    startAltitude: data["minAltitude"] as? Int,
                    peakAltitude: data["maxAltitude"] as? Int,
                    endAltitude: data["endAltitude"] as? Int,
                    minAltitude: data["minAltitude"] as? Int ?? 0,
                    maxAltitude: data["maxAltitude"] as? Int ?? 0,
                    totalAltitude: data["totalAltitude"] as? Int ?? 0,
                    totalDistance: data["totalDistance"] as? Double,
                    ascendAvgSpeed: data["ascendAvgSpeed"] as? Int,
                    descendAvgSpeed: data["descendAvgSpeed"] as? Int,
                    avgSpeed: data["avgSpeed"] as? Double ?? 0.0,
                    avgImpulse: data["avgImpulse"] as? Double ?? 0.0,
                    hikingLogs: []
                )
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
                hikingRecord.hikingLogs = convertLogsToHikingLogs(from: logs as? [String: String] ?? [:])
                dataSource.saveItem(hikingRecord)
            } else {
                let newHikingRecord =
                HikingRecord(
                    id: UUID(uuidString: resultArray["id"] as? String ?? UUID().uuidString) ?? UUID(),
                    title: "-",
                    duration: 0,
                    minHeartRate: 0,
                    maxHeartRate: 0,
                    avgHeartRate: 0,
                    minAltitude: 0,
                    maxAltitude: 0,
                    totalAltitude: 0,
                    avgSpeed: 0.0,
                    avgImpulse: 0.0,
                    hikingLogs: convertLogsToHikingLogs(from: logs as? [String:String] ?? [:])
                )
                dataSource.saveItem(newHikingRecord)
                
            }
        }
    }

    func convertLogsToHikingLogs(from logs: [String:String]) -> [HikingLog] {
        var convertedLogs: [HikingLog] = []
        for (timeStampString, impulseLog) in logs {
            convertedLogs.append(
                HikingLog(
                    id: UUID(),
                    impulse: Double(impulseLog) ?? 0.0 ,
                    timeStamp: convertTimeStampStringToDateTime(from : timeStampString)
                )
            )
        }
        return convertedLogs
    }
    
    func convertTimeStampStringToDateTime(from timeStampString: String) -> Date {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust to match your date string's format
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
            
            // Parse the date string and return the Date object
            return dateFormatter.date(from: timeStampString) ?? Date()
    }
}
