import XCTest

class SignOutUseCaseTests: XCTestCase {
    
    enum SignOutError: Error {
        case failed
    }
    
    class AuthRepositoryMock: AuthRepository {
        var currentUser: UserProfile?
        var signOutCallsCount = 0
        var shouldThrowError = false
        
        func signInWithApple(
            presentationContextProvider: Any,
            completion: @escaping (Result<UserProfile, Error>) -> Void
        ) {
        }
        
        func getCurrentUser() -> UserProfile? {
            return currentUser
        }
        
        func signOut() throws {
            signOutCallsCount += 1
            if shouldThrowError {
                throw SignOutError.failed
            }
            currentUser = nil
        }
    }
    
    func testSignOutUseCase_whenSuccessful_thenClearsUserProfile() {
        let authRepository = AuthRepositoryMock()
        authRepository.currentUser = UserProfile(userId: "123", email: "test@example.com")
        
        let useCase = DefaultSignOutUseCase(authRepository: authRepository)
        
        XCTAssertNoThrow(try useCase.execute())
        XCTAssertEqual(authRepository.signOutCallsCount, 1)
        XCTAssertNil(authRepository.currentUser)
    }
    
    func testSignOutUseCase_whenFails_thenThrowsError() {
        let authRepository = AuthRepositoryMock()
        authRepository.shouldThrowError = true
        
        let useCase = DefaultSignOutUseCase(authRepository: authRepository)
        
        XCTAssertThrowsError(try useCase.execute())
        XCTAssertEqual(authRepository.signOutCallsCount, 1)
    }
}
