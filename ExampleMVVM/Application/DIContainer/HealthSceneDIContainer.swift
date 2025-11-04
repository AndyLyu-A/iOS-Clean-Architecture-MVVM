import UIKit

final class HealthSceneDIContainer: HealthFlowCoordinatorDependencies {
    
    struct Dependencies {
        // Future: Add network/storage services as needed
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository()
    }
    
    func makeHealthKitRepository() -> HealthKitRepository {
        return DefaultHealthKitRepository()
    }
    
    func makeSupplementsRepository() -> SupplementsRepository {
        return DefaultSupplementsRepository()
    }
    
    func makeAIRepository() -> AIRepository {
        return DefaultAIRepository()
    }
    
    func makeSecureStorageRepository() -> SecureStorageRepository {
        return DefaultSecureStorageRepository()
    }
    
    // MARK: - Use Cases
    func makeObserveAuthStateUseCase() -> ObserveAuthStateUseCase {
        return DefaultObserveAuthStateUseCase(authRepository: makeAuthRepository())
    }
    
    func makeRequestHealthAuthorizationUseCase() -> RequestHealthAuthorizationUseCase {
        return DefaultRequestHealthAuthorizationUseCase(healthKitRepository: makeHealthKitRepository())
    }
    
    func makeFetchHealthSummaryUseCase() -> FetchHealthSummaryUseCase {
        return DefaultFetchHealthSummaryUseCase(healthKitRepository: makeHealthKitRepository())
    }
    
    func makeFetchSupplementsUseCase() -> FetchSupplementsUseCase {
        return DefaultFetchSupplementsUseCase(supplementsRepository: makeSupplementsRepository())
    }
    
    func makeSaveSupplementUseCase() -> SaveSupplementUseCase {
        return DefaultSaveSupplementUseCase(supplementsRepository: makeSupplementsRepository())
    }
    
    func makeUpdateSupplementUseCase() -> UpdateSupplementUseCase {
        return DefaultUpdateSupplementUseCase(supplementsRepository: makeSupplementsRepository())
    }
    
    func makeDeleteSupplementUseCase() -> DeleteSupplementUseCase {
        return DefaultDeleteSupplementUseCase(supplementsRepository: makeSupplementsRepository())
    }
    
    func makeGenerateAISuggestionsUseCase() -> GenerateAISuggestionsUseCase {
        return DefaultGenerateAISuggestionsUseCase(aiRepository: makeAIRepository())
    }
    
    func makeSaveAPIKeyUseCase() -> SaveAPIKeyUseCase {
        return DefaultSaveAPIKeyUseCase(secureStorageRepository: makeSecureStorageRepository())
    }
    
    func makeGetAPIKeyUseCase() -> GetAPIKeyUseCase {
        return DefaultGetAPIKeyUseCase(secureStorageRepository: makeSecureStorageRepository())
    }
    
    // MARK: - Onboarding
    func makeOnboardingViewController(actions: OnboardingViewModelActions) -> UIViewController {
        return OnboardingViewController.create(
            with: makeOnboardingViewModel(actions: actions)
        )
    }
    
    func makeOnboardingViewModel(actions: OnboardingViewModelActions) -> OnboardingViewModel {
        return DefaultOnboardingViewModel(actions: actions)
    }
    
    // MARK: - Dashboard
    func makeDashboardViewController(actions: DashboardViewModelActions) -> UIViewController {
        return DashboardViewController.create(
            with: makeDashboardViewModel(actions: actions)
        )
    }
    
    func makeDashboardViewModel(actions: DashboardViewModelActions) -> DashboardViewModel {
        return DefaultDashboardViewModel(actions: actions)
    }
    
    // MARK: - Supplements List
    func makeSupplementsListViewController(actions: SupplementsListViewModelActions) -> UIViewController {
        return SupplementsListViewController.create(
            with: makeSupplementsListViewModel(actions: actions)
        )
    }
    
    func makeSupplementsListViewModel(actions: SupplementsListViewModelActions) -> SupplementsListViewModel {
        return DefaultSupplementsListViewModel(actions: actions)
    }
    
    // MARK: - Supplement Detail
    func makeSupplementDetailViewController(supplement: Supplement?, actions: SupplementDetailViewModelActions) -> UIViewController {
        return SupplementDetailViewController.create(
            with: makeSupplementDetailViewModel(supplement: supplement, actions: actions)
        )
    }
    
    func makeSupplementDetailViewModel(supplement: Supplement?, actions: SupplementDetailViewModelActions) -> SupplementDetailViewModel {
        return DefaultSupplementDetailViewModel(supplement: supplement, actions: actions)
    }
    
    // MARK: - Settings
    func makeSettingsViewController(actions: SettingsViewModelActions) -> UIViewController {
        return SettingsViewController.create(
            with: makeSettingsViewModel(actions: actions)
        )
    }
    
    func makeSettingsViewModel(actions: SettingsViewModelActions) -> SettingsViewModel {
        return DefaultSettingsViewModel(actions: actions)
    }
    
    // MARK: - Flow Coordinators
    func makeHealthFlowCoordinator(navigationController: UINavigationController) -> HealthFlowCoordinator {
        return HealthFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
