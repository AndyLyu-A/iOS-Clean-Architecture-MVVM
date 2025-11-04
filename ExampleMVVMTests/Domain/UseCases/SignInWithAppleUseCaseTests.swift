import XCTest

class SignInWithAppleUseCaseTests: XCTestCase {
    
    enum AuthRepositoryError: Error {
        case failed
    }
    
    class AuthRepositoryMock: AuthRepository {
        var result: Result<UserProfile, Error>?
        var signInCallsCount = 0
        var currentUser: UserProfile?
        
        func signInWithApple(
            presentationContextProvider: Any,
            completion: @escaping (Result<UserProfile, Error>) -> Void
        ) {
            signInCallsCount += 1
            if let result = result {
                completion(result)
            }
        }
        
        func getCurrentUser() -> UserProfile? {
            return currentUser
        }
        
        func signOut() throws {
            currentUser = nil
        }
    }
    
    func testSignInWithAppleUseCase_whenSuccessful_thenReturnsUserProfile() {
        let expectedProfile = UserProfile(userId: "123", email: "test@example.com", fullName: "Test User")
        let authRepository = AuthRepositoryMock()
        authRepository.result = .success(expectedProfile)
        
        let useCase = DefaultSignInWithAppleUseCase(authRepository: authRepository)
        
        var receivedProfile: UserProfile?
        let expectation = self.expectation(description: "SignIn completes")
        
        useCase.execute(presentationContextProvider: self) { result in
            if case .success(let profile) = result {
                receivedProfile = profile
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(authRepository.signInCallsCount, 1)
        XCTAssertEqual(receivedProfile, expectedProfile)
    }
    
    func testSignInWithAppleUseCase_whenFailed_thenReturnsError() {
        let authRepository = AuthRepositoryMock()
        authRepository.result = .failure(AuthRepositoryError.failed)
        
        let useCase = DefaultSignInWithAppleUseCase(authRepository: authRepository)
        
        var receivedError: Error?
        let expectation = self.expectation(description: "SignIn fails")
        
        useCase.execute(presentationContextProvider: self) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(authRepository.signInCallsCount, 1)
        XCTAssertNotNil(receivedError)
    }
}
