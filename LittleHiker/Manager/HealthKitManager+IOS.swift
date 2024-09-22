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
    
    func saveWorkoutData(uuidString: String) {
        fetchWorkoutByUUID(uuidString: uuidString) { workout in
            guard let workout = workout else {
                print("No workout found with UUID: \(uuidString)")
                return
            }
            
            DispatchQueue.main.async {
                let hikingRecord = self.createHikingRecord(uuidString, workout)
                self.dataSource.saveItem(hikingRecord)
            }
        }
    }
    
    // UUID로 workout 정보 가져옴
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

    // TODO: - HikingLog에 저장해야함. HikingRecord 저장용으로 가공해야 함
    /// HKQuery로 정보 가지고 오는 함수(현재는 심박수, 고도)
    func fetchHKQueryInfo(uuidString: String, completion: @escaping (_ heartRates: [(Double, Date)], _ altitudes: [(Double, Date)]) -> Void) {
        fetchWorkoutByUUID(uuidString: uuidString) { workout in
            guard let workout = workout else {
                print("No workout found with UUID: \(uuidString)")
                completion([], []) // No workout, return empty arrays
                return
            }
            
            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let altitudeType = HKObjectType.quantityType(forIdentifier: .height)!
            
            var heartRates: [(Double, Date)] = []
            var altitudes: [(Double, Date)] = []
            
            let dispatchGroup = DispatchGroup()
            
            // 심박수 데이터 가져오기
            dispatchGroup.enter()
            self.fetchSamples(for: heartRateType, workout: workout, unit: HKUnit(from: "count/min")) { sample in
                let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                let timestamp = sample.startDate
                heartRates.append((heartRate, timestamp))
            }
            
            // 고도 데이터 가져오기
            dispatchGroup.enter()
            self.fetchSamples(for: altitudeType, workout: workout, unit: HKUnit.meter()) { sample in
                let altitude = sample.quantity.doubleValue(for: HKUnit.meter())
                let timestamp = sample.startDate
                altitudes.append((altitude, timestamp))
            }
            
            // 쿼리가 완료되면 결과를 completion handler에 전달
            dispatchGroup.notify(queue: .main) {
                completion(heartRates, altitudes)
            }
        }
    }

    /// HKSample 정보 가지고 오는 함수
    func fetchSamples(for type: HKQuantityType, workout: HKWorkout, unit: HKUnit, sampleHandler: @escaping (HKQuantitySample) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            if let error = error {
                print("Error fetching samples: \(error.localizedDescription)")
                return
            }
            
            guard let quantitySamples = samples as? [HKQuantitySample] else {
                print("No samples found for \(type.identifier).")
                return
            }
            
            for sample in quantitySamples {
                sampleHandler(sample)
            }
        }
        
        self.healthStore.execute(query)
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
