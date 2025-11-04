import UIKit

final class HealthDashboardSceneDIContainer: HealthDashboardFlowCoordinatorDependencies {
    
    // MARK: - Repositories
    func makeHealthDataRepository() -> HealthDataRepository {
        DefaultHealthDataRepository()
    }
    
    // MARK: - Use Cases
    func makeRequestHealthAuthorizationUseCase() -> RequestHealthAuthorizationUseCase {
        DefaultRequestHealthAuthorizationUseCase(
            healthDataRepository: makeHealthDataRepository()
        )
    }
    
    func makeFetchHealthSummaryUseCase() -> FetchHealthSummaryUseCase {
        DefaultFetchHealthSummaryUseCase(
            healthDataRepository: makeHealthDataRepository()
        )
    }
    
    // MARK: - Health Dashboard
    func makeHealthDashboardViewController(
        actions: HealthDashboardViewModelActions
    ) -> HealthDashboardViewController {
        HealthDashboardViewController.create(
            with: makeHealthDashboardViewModel(actions: actions)
        )
    }
    
    func makeHealthDashboardViewModel(
        actions: HealthDashboardViewModelActions
    ) -> HealthDashboardViewModel {
        DefaultHealthDashboardViewModel(
            requestAuthorizationUseCase: makeRequestHealthAuthorizationUseCase(),
            fetchHealthSummaryUseCase: makeFetchHealthSummaryUseCase(),
            actions: actions
        )
    }
    
    // MARK: - Flow Coordinators
    func makeHealthDashboardFlowCoordinator(
        navigationController: UINavigationController
    ) -> HealthDashboardFlowCoordinator {
        HealthDashboardFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
