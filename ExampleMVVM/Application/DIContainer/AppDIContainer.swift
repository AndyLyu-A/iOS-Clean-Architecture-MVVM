import Foundation

final class AppDIContainer {
    
    // MARK: - DIContainers of scenes
    func makeHealthSceneDIContainer() -> HealthSceneDIContainer {
        let dependencies = HealthSceneDIContainer.Dependencies()
        return HealthSceneDIContainer(dependencies: dependencies)
    }
}
