import Foundation

protocol ObserveAuthStateUseCase {
    func execute(completion: @escaping (Result<UserProfile?, Error>) -> Void) -> Cancellable?
}

final class DefaultObserveAuthStateUseCase: ObserveAuthStateUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(completion: @escaping (Result<UserProfile?, Error>) -> Void) -> Cancellable? {
        return authRepository.observeAuthState(completion: completion)
    }
}
