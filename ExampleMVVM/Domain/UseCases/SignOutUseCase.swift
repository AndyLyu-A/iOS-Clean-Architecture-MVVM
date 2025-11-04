import Foundation

protocol SignOutUseCase {
    func execute() throws
}

final class DefaultSignOutUseCase: SignOutUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute() throws {
        try authRepository.signOut()
    }
}
