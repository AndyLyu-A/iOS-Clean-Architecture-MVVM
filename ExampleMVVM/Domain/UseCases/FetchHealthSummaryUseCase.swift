import Foundation

protocol FetchHealthSummaryUseCase {
    func execute(for dateRange: DateRange, completion: @escaping (Result<HealthSummary, Error>) -> Void)
}

final class DefaultFetchHealthSummaryUseCase: FetchHealthSummaryUseCase {
    private let healthKitRepository: HealthKitRepository
    
    init(healthKitRepository: HealthKitRepository) {
        self.healthKitRepository = healthKitRepository
    }
    
    func execute(for dateRange: DateRange, completion: @escaping (Result<HealthSummary, Error>) -> Void) {
        healthKitRepository.fetchHealthSummary(for: dateRange, completion: completion)
    }
}
