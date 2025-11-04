import Foundation

protocol RequestHealthAuthorizationUseCase {
    func execute(completion: @escaping (Result<Bool, Error>) -> Void)
}

final class DefaultRequestHealthAuthorizationUseCase: RequestHealthAuthorizationUseCase {
    private let healthKitRepository: HealthKitRepository
    
    init(healthKitRepository: HealthKitRepository) {
        self.healthKitRepository = healthKitRepository
    }
    
    func execute(completion: @escaping (Result<Bool, Error>) -> Void) {
        healthKitRepository.requestAuthorization(completion: completion)
    }
}
