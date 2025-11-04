import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let healthSceneDIContainer = appDIContainer.makeHealthSceneDIContainer()
        let flow = healthSceneDIContainer.makeHealthFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
