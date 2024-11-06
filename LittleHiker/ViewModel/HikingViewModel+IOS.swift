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
            
            var hikingRecords = dataSource.fetchHikingRecords()
            if let data = resultArray["data"] as? [String: Any] {
                // 스위프트 데이터에 watch에서 온 데이터가 있으면
                if let hikingRecord = hikingRecords.first(where: {$0.id == data["id"] as? UUID}) {
                    hikingRecord.id = data["id"] as! UUID
                    hikingRecord.startDateTime = data["startDate"] as! Date
                    hikingRecord.endDateTime = data["endDate"] as! Date
                    hikingRecord.duration = data["duration"] as! Int
                } else {
                    let newHikingRecord = HikingRecord(
                        id: data["id"] as? UUID ?? UUID(),
                        title: "aa",
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
                        hikingLog: []
                    )
                    dataSource.saveItem(newHikingRecord)
                }
            } else {
//                var title: String       //iOS title
//                var duration: Int       //등산소요시간
//                var startDateTime: Date //시작시간
//                // var peakDateTime 필요하네
//                var endDateTime: Date   //종료시간
//                var startAltitude: Int  //시작고도
//                var peakAltitude: Int   //최고고도
//                var endAltitude: Int    //종료고도
//                var ascendAvgSpeed: Int //등산평균속도
//                var descendAvgSpeed: Int//하산평균속도
//                var avgForce: Int       //평균충격량
//                var painRate: Int? = nil //고통지수
//                var minHeartRate: Int   //최소심박수
//                var maxHeartRate: Int   //최고심박수
//                var avgHeartRate: Int   //평균심박수
                let newHikingRecord = HikingRecord(
                    id: data["id"],
                    title: "aa",
                    startDateTime: data["startDate"] as! Date,
                    endDateTime: data["endDate"] as! Date,
                    startAltitude: data["startAltitude"] as! Int,
                    endAltitude: data["endAltitude"] as! Int,
                    ascendAvgSpeed: data["ascendAvgSpeed"] as! Int,
                    descendAvgSpeed: data["descendAvgSpeed"] as! Int,
                    avgForce: data["avgForce"] as! Int,
                    painRate: data["painRate"] as? Int,
                    minHeartRate: data["minHeartRate"] as! Int,
                    maxHeartRate: data["maxHeartRate"] as! Int,
                    avgHeartRate: data["avgHeartRate"] as! Int
                )
            }
            
//            for todo in todoItemsPastDueDate {
//              if let todo = todos.first(where: { $0.id == todo.id }) {
//                  modelContext.delete(todo)
//                  deletionCount += 1
//              }
//            }
            
            if resultArray["data"] != nil { //summaryModel
                if let data = resultArray["data"] as? [String: Any] {
                    let uuid = resultArray["id"]
                    
                    // TODO: - 조회와 저장 분리
                    // 데이터 조회 및 저장
                    self.healthKitManager.saveWorkoutData(uuidString: uuid as! String)
                }
            } else if resultArray["logs"] != nil{ //log보냄
                if let logs = resultArray["logs"] as? [String: Any] {
                    let keys = logs.keys
                    
                    // 각 키를 출력
                    for key in keys {
//                    self.body.append("Key: \(key)")
                    }
                    
                } else {
//                self.body.append("Logs is not available or in unexpected format")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
