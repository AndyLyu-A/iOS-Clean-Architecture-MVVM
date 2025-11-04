import XCTest

class OnboardingViewModelTests: XCTestCase {
    
    enum SignInError: Error {
        case failed
        case networkError
    }
    
    class SignInWithAppleUseCaseMock: SignInWithAppleUseCase {
        var result: Result<UserProfile, Error>?
        var executeCallsCount = 0
        
        func execute(
            presentationContextProvider: Any,
            completion: @escaping (Result<UserProfile, Error>) -> Void
        ) {
            executeCallsCount += 1
            if let result = result {
                completion(result)
            }
        }
    }
    
    func testOnboardingViewModel_whenSignInSucceeds_thenCompletionIsCalled() {
        let expectedProfile = UserProfile(userId: "123", email: "test@example.com", fullName: "Test User")
        let signInUseCase = SignInWithAppleUseCaseMock()
        signInUseCase.result = .success(expectedProfile)
        
        var didComplete = false
        var completedProfile: UserProfile?
        let actions = OnboardingViewModelActions(
            signInDidComplete: { profile in
                didComplete = true
                completedProfile = profile
            }
        )
        
        let viewModel = DefaultOnboardingViewModel(
            signInWithAppleUseCase: signInUseCase,
            actions: actions,
            mainQueue: DispatchQueueTypeMock()
        )
        viewModel.presentationContextProvider = self
        
        viewModel.didTapSignIn()
        
        XCTAssertTrue(didComplete)
        XCTAssertEqual(completedProfile, expectedProfile)
        XCTAssertEqual(signInUseCase.executeCallsCount, 1)
        XCTAssertFalse(viewModel.isLoading.value)
        XCTAssertNil(viewModel.error.value)
    }
    
    func testOnboardingViewModel_whenSignInFails_thenErrorIsSet() {
        let signInUseCase = SignInWithAppleUseCaseMock()
        signInUseCase.result = .failure(SignInError.failed)
        
        var didComplete = false
        let actions = OnboardingViewModelActions(
            signInDidComplete: { _ in
                didComplete = true
            }
        )
        
        let viewModel = DefaultOnboardingViewModel(
            signInWithAppleUseCase: signInUseCase,
            actions: actions,
            mainQueue: DispatchQueueTypeMock()
        )
        viewModel.presentationContextProvider = self
        
        viewModel.didTapSignIn()
        
        XCTAssertFalse(didComplete)
        XCTAssertEqual(signInUseCase.executeCallsCount, 1)
        XCTAssertFalse(viewModel.isLoading.value)
        XCTAssertNotNil(viewModel.error.value)
    }
    
    func testOnboardingViewModel_whenSignInIsCancelled_thenNoErrorIsSet() {
        let signInUseCase = SignInWithAppleUseCaseMock()
        signInUseCase.result = .failure(AuthError.cancelled)
        
        var didComplete = false
        let actions = OnboardingViewModelActions(
            signInDidComplete: { _ in
                didComplete = true
            }
        )
        
        let viewModel = DefaultOnboardingViewModel(
            signInWithAppleUseCase: signInUseCase,
            actions: actions,
            mainQueue: DispatchQueueTypeMock()
        )
        viewModel.presentationContextProvider = self
        
        viewModel.didTapSignIn()
        
        XCTAssertFalse(didComplete)
        XCTAssertEqual(signInUseCase.executeCallsCount, 1)
        XCTAssertFalse(viewModel.isLoading.value)
        XCTAssertNil(viewModel.error.value)
    }
    
    func testOnboardingViewModel_whenSignInStarts_thenLoadingIsTrue() {
        let signInUseCase = SignInWithAppleUseCaseMock()
        
        let actions = OnboardingViewModelActions(
            signInDidComplete: { _ in }
        )
        
        let viewModel = DefaultOnboardingViewModel(
            signInWithAppleUseCase: signInUseCase,
            actions: actions,
            mainQueue: DispatchQueueTypeMock()
        )
        viewModel.presentationContextProvider = self
        
        var loadingStates: [Bool] = []
        viewModel.isLoading.observe(on: self) { isLoading in
            loadingStates.append(isLoading)
        }
        
        signInUseCase.result = .success(UserProfile(userId: "123"))
        viewModel.didTapSignIn()
        
        XCTAssertTrue(loadingStates.contains(true))
        XCTAssertFalse(viewModel.isLoading.value)
    }
    
    func testOnboardingViewModel_whenNoPresentationContext_thenErrorIsSet() {
        let signInUseCase = SignInWithAppleUseCaseMock()
        
        let actions = OnboardingViewModelActions(
            signInDidComplete: { _ in }
        )
        
        let viewModel = DefaultOnboardingViewModel(
            signInWithAppleUseCase: signInUseCase,
            actions: actions,
            mainQueue: DispatchQueueTypeMock()
        )
        
        viewModel.didTapSignIn()
        
        XCTAssertEqual(signInUseCase.executeCallsCount, 0)
        XCTAssertNotNil(viewModel.error.value)
    }
}
