import Foundation

class HealthDataRepositoryMock: HealthDataRepository {
    var authorizationStatus: HealthAuthorizationStatus = .notDetermined
    var requestAuthorizationResult: Result<HealthAuthorizationStatus, Error>?
    var fetchHealthSummaryResult: Result<HealthSummary, Error>?
    var requestAuthorizationCallCount = 0
    var fetchHealthSummaryCallCount = 0
    
    func requestAuthorization(completion: @escaping (Result<HealthAuthorizationStatus, Error>) -> Void) {
        requestAuthorizationCallCount += 1
        if let result = requestAuthorizationResult {
            completion(result)
        }
    }
    
    func fetchHealthSummary(completion: @escaping (Result<HealthSummary, Error>) -> Void) {
        fetchHealthSummaryCallCount += 1
        if let result = fetchHealthSummaryResult {
            completion(result)
        }
    }
    
    func getAuthorizationStatus() -> HealthAuthorizationStatus {
        return authorizationStatus
    }
}
