import Foundation

protocol HealthKitRepository {
    func requestAuthorization(completion: @escaping (Result<Bool, Error>) -> Void)
    func checkAuthorizationStatus() -> Bool
    func fetchHealthMetrics(for types: [HealthMetricType], in dateRange: DateRange, completion: @escaping (Result<[HealthMetric], Error>) -> Void)
    func fetchHealthSummary(for dateRange: DateRange, completion: @escaping (Result<HealthSummary, Error>) -> Void)
}
