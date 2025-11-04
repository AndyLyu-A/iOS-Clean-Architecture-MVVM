import Foundation

protocol RequestHealthAuthorizationUseCase {
    func execute(completion: @escaping (Result<HealthAuthorizationStatus, Error>) -> Void)
}

final class DefaultRequestHealthAuthorizationUseCase: RequestHealthAuthorizationUseCase {
    
    private let healthDataRepository: HealthDataRepository
    
    init(healthDataRepository: HealthDataRepository) {
        self.healthDataRepository = healthDataRepository
    }
    
    func execute(completion: @escaping (Result<HealthAuthorizationStatus, Error>) -> Void) {
        healthDataRepository.requestAuthorization(completion: completion)
    }
}
