import UIKit

protocol HealthFlowCoordinatorDependencies {
    func makeOnboardingViewController(
        actions: OnboardingViewModelActions
    ) -> OnboardingViewController
    func makeDashboardViewController(userProfile: UserProfile?) -> DashboardViewController
}

final class HealthFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: HealthFlowCoordinatorDependencies
    private let observeAuthStateUseCase: ObserveAuthStateUseCase
    private let signOutUseCase: SignOutUseCase
    
    init(
        navigationController: UINavigationController,
        dependencies: HealthFlowCoordinatorDependencies,
        observeAuthStateUseCase: ObserveAuthStateUseCase,
        signOutUseCase: SignOutUseCase
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.observeAuthStateUseCase = observeAuthStateUseCase
        self.signOutUseCase = signOutUseCase
    }
    
    func start() {
        if let _ = observeAuthStateUseCase.execute() {
            showDashboard()
        } else {
            showOnboarding()
        }
    }
    
    private func showOnboarding() {
        let actions = OnboardingViewModelActions(
            signInDidComplete: { [weak self] _ in
                self?.showDashboard()
            }
        )
        let viewController = dependencies.makeOnboardingViewController(actions: actions)
        navigationController?.setViewControllers([viewController], animated: false)
    }
    
    private func showDashboard() {
        let userProfile = observeAuthStateUseCase.execute()
        let viewController = dependencies.makeDashboardViewController(userProfile: userProfile)
        viewController.delegate = self
        navigationController?.setViewControllers([viewController], animated: true)
    }
}

extension HealthFlowCoordinator: DashboardViewControllerDelegate {
    func didTapSignOut() {
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            self?.performSignOut()
        })
        
        navigationController?.present(alert, animated: true)
    }
    
    private func performSignOut() {
        do {
            try signOutUseCase.execute()
            showOnboarding()
        } catch {
            let alert = UIAlertController(
                title: "Error",
                message: "Failed to sign out: \(error.localizedDescription)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            navigationController?.present(alert, animated: true)
        }
    }
}
