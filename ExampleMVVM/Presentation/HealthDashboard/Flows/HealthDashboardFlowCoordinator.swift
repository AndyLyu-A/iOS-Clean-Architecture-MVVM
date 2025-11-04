import UIKit

protocol HealthDashboardFlowCoordinatorDependencies {
    func makeHealthDashboardViewController(
        actions: HealthDashboardViewModelActions
    ) -> HealthDashboardViewController
}

final class HealthDashboardFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: HealthDashboardFlowCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: HealthDashboardFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = HealthDashboardViewModelActions(
            openSettings: openSettings
        )
        let vc = dependencies.makeHealthDashboardViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
}
