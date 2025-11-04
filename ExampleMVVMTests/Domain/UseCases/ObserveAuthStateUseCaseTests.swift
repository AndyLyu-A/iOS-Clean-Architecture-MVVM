import XCTest

class ObserveAuthStateUseCaseTests: XCTestCase {
    
    class AuthRepositoryMock: AuthRepository {
        var currentUser: UserProfile?
        
        func signInWithApple(
            presentationContextProvider: Any,
            completion: @escaping (Result<UserProfile, Error>) -> Void
        ) {
        }
        
        func getCurrentUser() -> UserProfile? {
            return currentUser
        }
        
        func signOut() throws {
            currentUser = nil
        }
    }
    
    func testObserveAuthStateUseCase_whenUserIsAuthenticated_thenReturnsUserProfile() {
        let expectedProfile = UserProfile(userId: "123", email: "test@example.com", fullName: "Test User")
        let authRepository = AuthRepositoryMock()
        authRepository.currentUser = expectedProfile
        
        let useCase = DefaultObserveAuthStateUseCase(authRepository: authRepository)
        
        let result = useCase.execute()
        
        XCTAssertEqual(result, expectedProfile)
    }
    
    func testObserveAuthStateUseCase_whenUserIsNotAuthenticated_thenReturnsNil() {
        let authRepository = AuthRepositoryMock()
        authRepository.currentUser = nil
        
        let useCase = DefaultObserveAuthStateUseCase(authRepository: authRepository)
        
        let result = useCase.execute()
        
        XCTAssertNil(result)
    }
}
