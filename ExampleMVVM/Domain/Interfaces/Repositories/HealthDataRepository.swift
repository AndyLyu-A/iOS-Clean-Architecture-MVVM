import Foundation

enum HealthAuthorizationStatus {
    case notDetermined
    case authorized
    case denied
}

protocol HealthDataRepository {
    func requestAuthorization(completion: @escaping (Result<HealthAuthorizationStatus, Error>) -> Void)
    func fetchHealthSummary(completion: @escaping (Result<HealthSummary, Error>) -> Void)
    func getAuthorizationStatus() -> HealthAuthorizationStatus
}
