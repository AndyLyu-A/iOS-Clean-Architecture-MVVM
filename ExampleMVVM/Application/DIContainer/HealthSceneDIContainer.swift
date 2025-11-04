import UIKit

final class HealthSceneDIContainer {
    
    struct Dependencies {
    }
    
    private let dependencies: Dependencies
    
    private lazy var secureStorageRepository: SecureStorageRepository = {
        return KeychainSecureStorageRepository()
    }()
    
    private lazy var authRepository: AuthRepository = {
        return DefaultAuthRepository(secureStorage: secureStorageRepository)
    }()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeObserveAuthStateUseCase() -> ObserveAuthStateUseCase {
        return DefaultObserveAuthStateUseCase(authRepository: authRepository)
    }
    
    func makeSignInWithAppleUseCase() -> SignInWithAppleUseCase {
        return DefaultSignInWithAppleUseCase(authRepository: authRepository)
    }
    
    func makeSignOutUseCase() -> SignOutUseCase {
        return DefaultSignOutUseCase(authRepository: authRepository)
    }
    
    func makeHealthFlowCoordinator(
        navigationController: UINavigationController
    ) -> HealthFlowCoordinator {
        return HealthFlowCoordinator(
            navigationController: navigationController,
            dependencies: self,
            observeAuthStateUseCase: makeObserveAuthStateUseCase(),
            signOutUseCase: makeSignOutUseCase()
        )
    }
    
    func makeOnboardingViewController(
        actions: OnboardingViewModelActions
    ) -> OnboardingViewController {
        return OnboardingViewController.create(
            with: makeOnboardingViewModel(actions: actions)
        )
    }
    
    private func makeOnboardingViewModel(
        actions: OnboardingViewModelActions
    ) -> OnboardingViewModel {
        return DefaultOnboardingViewModel(
            signInWithAppleUseCase: makeSignInWithAppleUseCase(),
            actions: actions
        )
    }
    
    func makeDashboardViewController(userProfile: UserProfile?) -> DashboardViewController {
        return DashboardViewController(userProfile: userProfile)
    }
}

extension HealthSceneDIContainer: HealthFlowCoordinatorDependencies { }
