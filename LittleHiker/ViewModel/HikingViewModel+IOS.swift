//
//  HikingViewModel+IOS.swift
//  LittleHiker
//
//  Created by 백록담 on 8/29/24.
//
import Foundation
import HealthKit

class HikingViewModel {
    public func saveDataFromWatch(_ data: Data) {
        do {
            let resultArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
            if resultArray["data"] != nil {
                // Optional로 반환된 데이터를 안전하게 언래핑
                if let data = resultArray["data"] as? [String: Any] {
                    let uuid = resultArray["id"]
                    
                    // TODO: - 조회와 저장 분리
                    // 데이터 조회 및 저장
                    HealthKitManager().fetchWorkoutWithUUID(uuid as! String)
                } else {
                    //                self.body.append("Data is not available or in unexpected format")
                }
            } else if resultArray["logs"] != nil{
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
