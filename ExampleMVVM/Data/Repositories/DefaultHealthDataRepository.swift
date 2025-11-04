import Foundation
import HealthKit

final class DefaultHealthDataRepository {
    
    private let healthStore: HKHealthStore
    private let backgroundQueue: DispatchQueue
    
    init(
        healthStore: HKHealthStore = HKHealthStore(),
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.healthStore = healthStore
        self.backgroundQueue = backgroundQueue
    }
    
    private func getHealthDataTypes() -> Set<HKSampleType> {
        var types = Set<HKSampleType>()
        
        if let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) {
            types.insert(stepType)
        }
        if let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) {
            types.insert(heartRateType)
        }
        if let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) {
            types.insert(sleepType)
        }
        if let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) {
            types.insert(exerciseType)
        }
        
        return types
    }
}

extension DefaultHealthDataRepository: HealthDataRepository {
    
    func requestAuthorization(completion: @escaping (Result<HealthAuthorizationStatus, Error>) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            let error = NSError(
                domain: "HealthKit",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device"]
            )
            completion(.failure(error))
            return
        }
        
        let types = getHealthDataTypes()
        
        healthStore.requestAuthorization(toShare: [], read: types) { [weak self] success, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let status = self?.getAuthorizationStatus() ?? .notDetermined
            completion(.success(status))
        }
    }
    
    func getAuthorizationStatus() -> HealthAuthorizationStatus {
        guard HKHealthStore.isHealthDataAvailable() else {
            return .denied
        }
        
        let types = getHealthDataTypes()
        var hasAuthorization = false
        
        for type in types {
            let status = healthStore.authorizationStatus(for: type)
            if status == .sharingAuthorized {
                hasAuthorization = true
                break
            }
        }
        
        return hasAuthorization ? .authorized : .notDetermined
    }
    
    func fetchHealthSummary(completion: @escaping (Result<HealthSummary, Error>) -> Void) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            
            let group = DispatchGroup()
            var steps: HealthMetric?
            var heartRate: HealthMetric?
            var sleep: HealthMetric?
            var activeMinutes: HealthMetric?
            var fetchError: Error?
            
            // Fetch steps
            group.enter()
            self.fetchSteps { result in
                switch result {
                case .success(let metric):
                    steps = metric
                case .failure(let error):
                    fetchError = error
                }
                group.leave()
            }
            
            // Fetch heart rate
            group.enter()
            self.fetchHeartRate { result in
                switch result {
                case .success(let metric):
                    heartRate = metric
                case .failure:
                    break
                }
                group.leave()
            }
            
            // Fetch sleep
            group.enter()
            self.fetchSleep { result in
                switch result {
                case .success(let metric):
                    sleep = metric
                case .failure:
                    break
                }
                group.leave()
            }
            
            // Fetch active minutes
            group.enter()
            self.fetchActiveMinutes { result in
                switch result {
                case .success(let metric):
                    activeMinutes = metric
                case .failure:
                    break
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                if let error = fetchError {
                    completion(.failure(error))
                    return
                }
                
                let summary = HealthSummary(
                    steps: steps,
                    heartRate: heartRate,
                    sleep: sleep,
                    activeMinutes: activeMinutes,
                    lastUpdated: Date()
                )
                completion(.success(summary))
            }
        }
    }
    
    private func fetchSteps(completion: @escaping (Result<HealthMetric, Error>) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            let error = NSError(
                domain: "HealthKit",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Step count type not available"]
            )
            completion(.failure(error))
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, statistics, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let sum = statistics?.sumQuantity() else {
                let metric = HealthMetric(
                    type: .steps,
                    value: 0,
                    unit: "steps",
                    date: now
                )
                completion(.success(metric))
                return
            }
            
            let steps = sum.doubleValue(for: HKUnit.count())
            let metric = HealthMetric(
                type: .steps,
                value: steps,
                unit: "steps",
                date: now
            )
            completion(.success(metric))
        }
        
        healthStore.execute(query)
    }
    
    private func fetchHeartRate(completion: @escaping (Result<HealthMetric, Error>) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            let error = NSError(
                domain: "HealthKit",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Heart rate type not available"]
            )
            completion(.failure(error))
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [sortDescriptor]
        ) { _, samples, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let sample = samples?.first as? HKQuantitySample else {
                let metric = HealthMetric(
                    type: .heartRate,
                    value: 0,
                    unit: "bpm",
                    date: Date()
                )
                completion(.success(metric))
                return
            }
            
            let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
            let metric = HealthMetric(
                type: .heartRate,
                value: heartRate,
                unit: "bpm",
                date: sample.endDate
            )
            completion(.success(metric))
        }
        
        healthStore.execute(query)
    }
    
    private func fetchSleep(completion: @escaping (Result<HealthMetric, Error>) -> Void) {
        guard let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else {
            let error = NSError(
                domain: "HealthKit",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Sleep analysis type not available"]
            )
            completion(.failure(error))
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKSampleQuery(
            sampleType: sleepType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { _, samples, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let samples = samples as? [HKCategorySample] else {
                let metric = HealthMetric(
                    type: .sleep,
                    value: 0,
                    unit: "hours",
                    date: now
                )
                completion(.success(metric))
                return
            }
            
            var totalSleepTime: TimeInterval = 0
            for sample in samples {
                if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue ||
                   sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue {
                    totalSleepTime += sample.endDate.timeIntervalSince(sample.startDate)
                }
            }
            
            let hours = totalSleepTime / 3600.0
            let metric = HealthMetric(
                type: .sleep,
                value: hours,
                unit: "hours",
                date: now
            )
            completion(.success(metric))
        }
        
        healthStore.execute(query)
    }
    
    private func fetchActiveMinutes(completion: @escaping (Result<HealthMetric, Error>) -> Void) {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
            let error = NSError(
                domain: "HealthKit",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Exercise time type not available"]
            )
            completion(.failure(error))
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(
            quantityType: exerciseType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, statistics, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let sum = statistics?.sumQuantity() else {
                let metric = HealthMetric(
                    type: .activeMinutes,
                    value: 0,
                    unit: "minutes",
                    date: now
                )
                completion(.success(metric))
                return
            }
            
            let minutes = sum.doubleValue(for: HKUnit.minute())
            let metric = HealthMetric(
                type: .activeMinutes,
                value: minutes,
                unit: "minutes",
                date: now
            )
            completion(.success(metric))
        }
        
        healthStore.execute(query)
    }
}
