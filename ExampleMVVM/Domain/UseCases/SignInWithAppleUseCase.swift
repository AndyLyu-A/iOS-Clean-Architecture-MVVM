import Foundation

protocol SignInWithAppleUseCase {
    func execute(
        presentationContextProvider: Any,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    )
}

final class DefaultSignInWithAppleUseCase: SignInWithAppleUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(
        presentationContextProvider: Any,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {
        authRepository.signInWithApple(
            presentationContextProvider: presentationContextProvider,
            completion: completion
        )
    }
}
