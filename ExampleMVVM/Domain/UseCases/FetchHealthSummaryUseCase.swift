import Foundation

protocol FetchHealthSummaryUseCase {
    func execute(completion: @escaping (Result<HealthSummary, Error>) -> Void)
}

final class DefaultFetchHealthSummaryUseCase: FetchHealthSummaryUseCase {
    
    private let healthDataRepository: HealthDataRepository
    
    init(healthDataRepository: HealthDataRepository) {
        self.healthDataRepository = healthDataRepository
    }
    
    func execute(completion: @escaping (Result<HealthSummary, Error>) -> Void) {
        let authStatus = healthDataRepository.getAuthorizationStatus()
        
        guard authStatus == .authorized else {
            let error = NSError(
                domain: "HealthKit",
                code: 403,
                userInfo: [NSLocalizedDescriptionKey: "HealthKit access not authorized"]
            )
            completion(.failure(error))
            return
        }
        
        healthDataRepository.fetchHealthSummary(completion: completion)
    }
}
