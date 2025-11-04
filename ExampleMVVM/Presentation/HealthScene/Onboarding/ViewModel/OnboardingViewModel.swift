import Foundation

struct OnboardingViewModelActions {
    let didCompleteOnboarding: () -> Void
}

protocol OnboardingViewModelInput {
    func didTapSignIn(email: String, password: String)
    func didTapSignUp(email: String, password: String, name: String?)
}

protocol OnboardingViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
}

protocol OnboardingViewModel: OnboardingViewModelInput, OnboardingViewModelOutput {}

final class DefaultOnboardingViewModel: OnboardingViewModel {
    
    private let actions: OnboardingViewModelActions
    
    let isLoading: Observable<Bool> = Observable(false)
    let error: Observable<String?> = Observable(nil)
    
    init(actions: OnboardingViewModelActions) {
        self.actions = actions
    }
    
    func didTapSignIn(email: String, password: String) {
        // TODO: Implement sign in logic
        isLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading.value = false
            self?.actions.didCompleteOnboarding()
        }
    }
    
    func didTapSignUp(email: String, password: String, name: String?) {
        // TODO: Implement sign up logic
        isLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading.value = false
            self?.actions.didCompleteOnboarding()
        }
    }
}
