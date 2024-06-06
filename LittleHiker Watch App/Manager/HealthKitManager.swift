//
//  HealthKitManager.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/17/24.
//

import Foundation
import Combine
import HealthKit

class HealthKitManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        print("ds1")
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        print("ds2")

    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("ds3")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: any Error) {
        print("ds4")
    }
    
    @Published var currentHeartRate: Int = 0
    @Published var currentDistanceWalkingRunning: Double = 0
    var heartRateLogs: [Int] = []
    var distanceLogs: [Double] = []
    private var anchor: HKQueryAnchor? //앵커 저장 변수
    private var startDate: Date? // 시작 시점 저장 변수
    private var totalDistanceWalkingRunning: Double = 0.0
    
    private var timer: Timer?
    
    //MARK: - HKHealthStore 불러오기
//    let healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    let distanceQuantity = HKUnit.meter()
    //심박수 평균을 위한 시작 시간

    //workout
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKLiveWorkoutBuilder?
    
    override init() {
        super.init()
        authorizeHealthKit()
//        startTimer()
    }

    
    let healthStore = HKHealthStore()

    // MARK: - HealthKit 사용 권한 인증
    func authorizeHealthKit() {
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
//            HKObjectType.quantityType(forIdentifier: .stepCount)!,
//            HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, //
//            HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        let writeTypes: Set<HKSampleType> = [
            HKObjectType.workoutType()
        ]

        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
            if !success {
                print("HealthKit authorization failed: \(String(describing: error))")

            }
            self.hkQuery(quantityTypeIdentifier: .heartRate)
            //            self?.hkQuery(quantityTypeIdentifier: .distanceWalkingRunning)

        }
    }
    
    func startHikingWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .hiking //hikingMode
        configuration.locationType = .outdoor //외부

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()

            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

            workoutSession?.delegate = self
            workoutBuilder?.delegate = self

            workoutSession?.startActivity(with: Date())
            workoutBuilder?.beginCollection(withStart: Date()) { (success, error) in
                if let error = error {
                    // Handle the error here.
                    print("Failed to begin collection: \(error.localizedDescription)")
                }
            }
        } catch {
            // Handle errors here
            print("Failed to start workout session: \(error.localizedDescription)")
        }
    }

    func endHikingWorkout() {
        workoutSession?.end()
        workoutBuilder?.endCollection(withEnd: Date()) { (success, error) in
            self.workoutBuilder?.finishWorkout { (workout, error) in
                // Handle post-workout processing if needed
                if let error = error {
                    print("Failed to finish workout: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //append 기능 추가
    func appendHealthKitLogs(isRecord: Bool){
        if isRecord {
            heartRateLogs.append(currentHeartRate)
            distanceLogs.append(currentDistanceWalkingRunning)
        } else {
            heartRateLogs.append(0)
            distanceLogs.append(0.0)
        }
    }
    
    public func hkQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let queryAnchor = loadQueryAnchor(quantityTypeIdentifier)
        
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
                        
            if (quantityTypeIdentifier == .heartRate) {
                self.processHeartRate(samples)
            }
            
            if let newQueryAnchor = queryAnchor {
                self.saveQueryAnchor(newQueryAnchor, quantityTypeIdentifier)
            }
        }
        
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: queryAnchor, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        healthStore.execute(query)
    }
    
    private func processHeartRate(_ samples: [HKQuantitySample]) {
        guard let lastSample = samples.last else { return }
        
        let lastHeartRate = lastSample.quantity.doubleValue(for: heartRateQuantity)
        
        DispatchQueue.main.async {
            self.currentHeartRate = Int(lastHeartRate)
        }
    }

//    private func processDistance(_ samples: [HKQuantitySample]) {
//        self.startDate = Date() // 현재 시점을 시작 시점으로 설정
//
//        for sample in samples {
//            guard let startDate = self.startDate, sample.startDate >= startDate else {
//                continue // 시작 시점 이후의 데이터만 처리
//            }
//
//            let distance = sample.quantity.doubleValue(for: distanceQuantity)
//            totalDistanceWalkingRunning += distance
//
//            DispatchQueue.main.async {
//                self.currentDistanceWalkingRunning = self.totalDistanceWalkingRunning
//            }
//        }
//    }
    
    func fetchHeartRateStatistics(completion: @escaping (Double?, Double?, Double?, Error?) -> Void) {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            guard let results = results as? [HKQuantitySample], error == nil else {
                completion(nil, nil, nil, error)
                return
            }
            
            // 심박수 데이터의 합과 개수를 계산하여 평균값 도출, 최소값 및 최대값 초기화
            var totalHeartRate = 0.0
            var count = 0.0
            var minHeartRate = Double.greatestFiniteMagnitude
            var maxHeartRate = Double.leastNormalMagnitude
            
            for sample in results {
                let heartRateUnit = HKUnit(from: "count/min")
                let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                totalHeartRate += heartRate
                count += 1
                
                if heartRate < minHeartRate {
                    minHeartRate = heartRate
                }
                
                if heartRate > maxHeartRate {
                    maxHeartRate = heartRate
                }
            }
            
            let averageHeartRate = count == 0 ? 0 : totalHeartRate / count
            minHeartRate = count == 0 ? 0 : minHeartRate
            maxHeartRate = count == 0 ? 0 : maxHeartRate
            
            completion(averageHeartRate, minHeartRate, maxHeartRate, nil)
        }
        
        healthStore.execute(query)
    }
    
    private func saveQueryAnchor(_ queryAnchor: HKQueryAnchor , _ quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        if let anchorData = try? NSKeyedArchiver.archivedData(withRootObject: queryAnchor, requiringSecureCoding: true) {
            UserDefaults.standard.set(anchorData, forKey: quantityTypeIdentifier.rawValue)
        }
    }
    
    private func loadQueryAnchor(_ quantityTypeIdentifier: HKQuantityTypeIdentifier) -> HKQueryAnchor? {
        guard let data = UserDefaults.standard.data(forKey: quantityTypeIdentifier.rawValue) else {
            return nil
        }
        
        do {
            let queryAnchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data)
            return queryAnchor
        } catch {
            print("Failed to load query anchor: \(error.localizedDescription)")
            return nil
        }
    }
        
    
    deinit {
        timer?.invalidate()
    }
}
