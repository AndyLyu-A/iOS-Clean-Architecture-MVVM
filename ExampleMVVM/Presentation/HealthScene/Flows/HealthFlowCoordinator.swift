import UIKit

protocol HealthFlowCoordinatorDependencies {
    func makeOnboardingViewController(actions: OnboardingViewModelActions) -> UIViewController
    func makeDashboardViewController(actions: DashboardViewModelActions) -> UIViewController
    func makeSupplementsListViewController(actions: SupplementsListViewModelActions) -> UIViewController
    func makeSupplementDetailViewController(supplement: Supplement?, actions: SupplementDetailViewModelActions) -> UIViewController
    func makeSettingsViewController(actions: SettingsViewModelActions) -> UIViewController
}

final class HealthFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: HealthFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: HealthFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = OnboardingViewModelActions(
            didCompleteOnboarding: showDashboard
        )
        let vc = dependencies.makeOnboardingViewController(actions: actions)
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    private func showDashboard() {
        let actions = DashboardViewModelActions(
            showSupplements: showSupplementsList,
            showSettings: showSettings
        )
        let vc = dependencies.makeDashboardViewController(actions: actions)
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    private func showSupplementsList() {
        let actions = SupplementsListViewModelActions(
            showSupplementDetail: showSupplementDetail,
            didUpdateSupplements: { }
        )
        let vc = dependencies.makeSupplementsListViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showSupplementDetail(supplement: Supplement?) {
        let actions = SupplementDetailViewModelActions(
            didSaveSupplement: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            },
            didDeleteSupplement: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        let vc = dependencies.makeSupplementDetailViewController(supplement: supplement, actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showSettings() {
        let actions = SettingsViewModelActions(
            didSignOut: start
        )
        let vc = dependencies.makeSettingsViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
}
