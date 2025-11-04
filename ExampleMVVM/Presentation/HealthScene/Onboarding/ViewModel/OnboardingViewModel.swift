import Foundation

struct OnboardingViewModelActions {
    let signInDidComplete: (UserProfile) -> Void
}

protocol OnboardingViewModelInput {
    func didTapSignIn()
}

protocol OnboardingViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
}

protocol OnboardingViewModel: OnboardingViewModelInput, OnboardingViewModelOutput { }

final class DefaultOnboardingViewModel: OnboardingViewModel {
    
    private let signInWithAppleUseCase: SignInWithAppleUseCase
    private let actions: OnboardingViewModelActions
    private let mainQueue: DispatchQueueType
    
    weak var presentationContextProvider: Any?
    
    let isLoading: Observable<Bool> = Observable(false)
    let error: Observable<String?> = Observable(nil)
    
    init(
        signInWithAppleUseCase: SignInWithAppleUseCase,
        actions: OnboardingViewModelActions,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.signInWithAppleUseCase = signInWithAppleUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }
    
    func didTapSignIn() {
        guard let contextProvider = presentationContextProvider else {
            error.value = "Unable to present sign in"
            return
        }
        
        isLoading.value = true
        error.value = nil
        
        signInWithAppleUseCase.execute(
            presentationContextProvider: contextProvider
        ) { [weak self] result in
            guard let self = self else { return }
            
            self.mainQueue.async {
                self.isLoading.value = false
                
                switch result {
                case .success(let userProfile):
                    self.actions.signInDidComplete(userProfile)
                case .failure(let error):
                    if case AuthError.cancelled = error {
                        return
                    }
                    self.error.value = error.localizedDescription
                }
            }
        }
    }
}
