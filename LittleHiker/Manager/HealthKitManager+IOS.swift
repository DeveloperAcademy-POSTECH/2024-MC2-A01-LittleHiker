//
//  HealthKitManager+IOS.swift
//  LittleHiker
//
//  Created by 백록담 on 8/29/24.
//

import Foundation
import HealthKit

class HealthKitManager {
    let dataSource: DataSource = DataSource.shared // SwiftData + MVVM을 위해 필요한 변수
    let healthStore = HKHealthStore()
    
    // uuid로 데이터 검색하기
    func fetchWorkoutWithUUID(_ id: String) {
        let healthStore = self.healthStore
        
        let workoutType = HKObjectType.workoutType()
        
        let workoutQuery = HKSampleQuery(sampleType: workoutType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            
            guard let workouts = samples as? [HKWorkout], error == nil else {
                print("Error fetching workouts: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // UUID로 특정 Workout 검색
            if let workout = workouts.first(where: { $0.uuid.uuidString == id }) {
                print("Found workout: \(workout)")
                // TODO: - 여기서 workout에 대한 추가 작업
                let hikingRecord = self.createHikingRecord(id, workout)
                self.dataSource.appendItem(hikingRecord)
            } else {
                print("No workout found with UUID: \(id)")
            }
        }
        
        healthStore.execute(workoutQuery)
    }
    
    func fetchWorkoutByUUID(uuidString: String, completion: @escaping (HKWorkout?) -> Void) {
        // UUID 객체 생성
        guard let uuid = UUID(uuidString: uuidString) else {
            completion(nil)
            return
        }
        
        // UUID로 검색하는 Predicate
        let predicate = HKQuery.predicateForObject(with: uuid)
        
        // Workout을 쿼리
        let workoutQuery = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicate, limit: 1, sortDescriptors: nil) { (query, samples, error) in
            
            if let error = error {
                print("Error fetching workout: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            let workout = samples?.first as? HKWorkout
            completion(workout)
        }
        
        healthStore.execute(workoutQuery)
    }

    // 심박수 가져오기(심박수 정보는 workout에 없어서 그 시간대 심박수로 조회해 와야 함)
    func fetchHeartRateForWorkout(uuidString: String) {
        fetchWorkoutByUUID(uuidString: uuidString) { workout in
            guard let workout = workout else {
                print("No workout found with UUID: \(uuidString)")
                return
            }
            
            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
            
            let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                
                if let error = error {
                    print("Error fetching heart rate samples: \(error.localizedDescription)")
                    return
                }
                
                guard let heartRateSamples = samples as? [HKQuantitySample] else {
                    print("No heart rate samples found.")
                    return
                }
                
                for sample in heartRateSamples {
                    let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                    let timestamp = sample.startDate
                    print("Heart Rate: \(heartRate) BPM at \(timestamp)")
                }
            }
            
            HKHealthStore().execute(query)
        }
    }
    
    func createHikingRecord(_ id: String, _ hkWorkOut: HKWorkout) -> HikingRecord {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let title = dateFormatter.string(from: hkWorkOut.startDate)

        // TODO: - 고도, 스피드, 충격량, 심박수는 workout 말고 따로 가지고 와야해서 일단 0으로 기록
        let hikingRecord = HikingRecord(
            id: id,
            title: title,
            duration: Int(hkWorkOut.duration),
            startDateTime: hkWorkOut.startDate,
            endDateTime: hkWorkOut.endDate,
            startAltitude: 0,
            peakAltitude: 0,
            endAltitude: 0,
            ascendAvgSpeed: 0,
            descendAvgSpeed: 0,
            avgForce: 0,
            minHeartRate: 0,
            maxHeartRate: 0,
            avgHeartRate: 0
        )
        
        return hikingRecord
    }
}
