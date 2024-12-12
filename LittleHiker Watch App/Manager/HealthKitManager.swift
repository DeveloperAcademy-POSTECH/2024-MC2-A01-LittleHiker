//
//  HealthKitManager.swift
//  LittleHiker Watch App
//
//  Created by sungkug_apple_developer_ac on 5/17/24.
//

import Foundation
import Combine
import HealthKit

class HealthKitManager: NSObject, ObservableObject {
    
    @Published var currentHeartRate: Int = 0
    @Published var currentDistanceWalkingRunning = 0.0
    @Published var currentSpeed = 0.0
    @Published var speedLogs: [Double] = []
    
    let healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    let distanceQuantity = HKUnit.meter()
    var heartRateLogs: [Int] = []
    var distanceLogs: [Double] = []
    private var startDate: Date?
    private var lastSpeedCheckDate: Date?
    private var speedCheckTimer: Timer?
    let checkTime = 4.0
    private var previousDistance: Double = 0.0
    private var previousTimestamp: Date?
    var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    private var SpeedLogForCorrection: [Double] = []
    var assignedUUIDString: String?
    
    override init() {
        super.init()
        authorizeHealthKit()
//        startSpeedCheckTimer()
    }
    
    private func startSpeedCheckTimer() {
        speedCheckTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            self.checkSpeed()
        }
    }
    // 정지 확인
    private func checkSpeed() {
        guard let lastSampleDate = lastSpeedCheckDate else {
            return
        }
        
        let currentTime = Date()
        let timeIntervalSinceLastSample = currentTime.timeIntervalSince(lastSampleDate)
        
        if timeIntervalSinceLastSample > checkTime {
            DispatchQueue.main.async {
                self.currentSpeed = 0.0
                print("정지 감지")
            }
        }
    }
    
    // MARK: - HealthKit 사용 권한 인증
    func authorizeHealthKit() {
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        
        let writeTypes: Set<HKSampleType> = [
            HKObjectType.workoutType()
        ]

        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
            
            if !success {
                print("HealthKit authorization failed: \(String(describing: error))")
            }
        }
    }
    
    //append 기능 추가
    func appendHealthKitLogs(isRecord: Bool) {
        if isRecord {
            heartRateLogs.append(currentHeartRate)
            distanceLogs.append(currentDistanceWalkingRunning)
            speedLogs.append(currentSpeed)

        } else {
            heartRateLogs.append(0)
            distanceLogs.append(0.0)
            speedLogs.append(0.0)
        }
    }
    // 종료 후 심박수 정보 요청
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
    
    func getAvgSpeed() -> Double {
        //0.5km/h이상의 값만 유효한 값으로 인식
        let nonZeroSpeedLogs = speedLogs.filter { $0 >= 0.5 }

        guard !nonZeroSpeedLogs.isEmpty else {
            return 0.0
        }
        
        let sum = nonZeroSpeedLogs.reduce(0, +)
        
        let average = sum / Double(nonZeroSpeedLogs.count)
        
        return average
    }
    
    deinit {
        speedCheckTimer?.invalidate()
        speedCheckTimer = nil
    }
}

//MARK: - Workout 관리 / 백그라운드에서 활성화 유지시키기 위함
extension HealthKitManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }
            
            if let statistics = workoutBuilder.statistics(for: quantityType) {
                let date = statistics.startDate
                
                if quantityType == HKQuantityType.quantityType(forIdentifier: .heartRate) {
                    if let heartRateValue = statistics.mostRecentQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())){
                        print("Heart Rate: \(String(describing: heartRateValue)) BPM at \(date)")
                        DispatchQueue.main.async {
                            self.currentHeartRate = Int(heartRateValue)
                        }
                    }
                } else if quantityType == HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) {
                    if let distanceValue = statistics.sumQuantity()?.doubleValue(for: HKUnit.meterUnit(with: .kilo)) {
                        let speed = calculateSpeedInKmh(currentDistance: distanceValue, currentTimestamp: Date())
                        print("Distance: \(distanceValue) meters, Speed: \(speed) km/h at \(date)")
                        DispatchQueue.main.async {
//                            self.currentSpeed = speed
                            self.SpeedLogForCorrection.append(speed)
                            self.currentDistanceWalkingRunning = distanceValue
                            self.correctionSpeed()
                        }
                    }
                }
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        print("이벤트 수집 처리")

    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("상태 변경 처리")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: any Error) {
        print("에러 처리")
    }
    
    func correctionSpeed() {
        if self.SpeedLogForCorrection.count > 2 {

            let sum = SpeedLogForCorrection.reduce(0, +)
            let average = sum / Double(SpeedLogForCorrection.count)

            self.currentSpeed = average
            self.SpeedLogForCorrection.removeFirst()
            lastSpeedCheckDate = Date()
            print("적용 속도 : \(average), 배열 : \(self.SpeedLogForCorrection)")
        } else {
            print("속도 데이터 수집중")
        }
    }
    
    // 속도 계산 함수
    func calculateSpeedInKmh(currentDistance: Double, currentTimestamp: Date) -> Double {
        guard let previousTimestamp = previousTimestamp else {
            self.previousDistance = currentDistance
            self.previousTimestamp = currentTimestamp
            return 0.0
        }

        let timeInterval = currentTimestamp.timeIntervalSince(previousTimestamp) / 3600.0 // 시간 단위로 변환
        let distanceDelta = (currentDistance - previousDistance)

        self.previousDistance = currentDistance
        self.previousTimestamp = currentTimestamp

        if timeInterval > 0 {
            return distanceDelta / timeInterval
        } else {
            return 0.0
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
                    print("Failed to begin collection: \(error.localizedDescription)")
                }
            }
            self.startDate = Date()
            self.startSpeedCheckTimer()
        } catch {
            print("Failed to start workout session: \(error.localizedDescription)")
        }
    }

    func endHikingWorkout() async -> Bool {
        guard let workoutSession = workoutSession,
              let workoutBuilder = workoutBuilder else {
            print("Workout session or builder is nil.")
            return false
        }

//        print("Before ending session: \(workoutSession.currentActivity?.uuid.uuidString ?? "No UUID")")

        // End the session
        workoutSession.end()

        // Use CheckedContinuation to wait for the asynchronous result
        return await withCheckedContinuation { continuation in
            workoutBuilder.endCollection(withEnd: Date()) { success, error in
                if let error = error {
                    print("Failed to end collection: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                    return
                }

                workoutBuilder.finishWorkout { workout, error in
                    if let error = error {
                        print("Failed to finish workout: \(error.localizedDescription)")
                        continuation.resume(returning: false)
                    } else if let savedWorkout = workout {
                        let uuidString = savedWorkout.uuid.uuidString
                        self.assignedUUIDString = uuidString
                        print("Workout saved with UUID: \(uuidString)")
                        continuation.resume(returning: true)
                    } else {
                        print("Unknown error finishing workout.")
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }

    
    func pauseHikingWorkout() {
        workoutSession?.pause()
    }
    
    func resumeHikingWorkout() {
        workoutSession?.resume()
    }
}
