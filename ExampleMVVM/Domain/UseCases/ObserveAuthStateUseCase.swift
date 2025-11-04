import Foundation

protocol ObserveAuthStateUseCase {
    func execute() -> UserProfile?
}

final class DefaultObserveAuthStateUseCase: ObserveAuthStateUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute() -> UserProfile? {
        return authRepository.getCurrentUser()
    }
}
