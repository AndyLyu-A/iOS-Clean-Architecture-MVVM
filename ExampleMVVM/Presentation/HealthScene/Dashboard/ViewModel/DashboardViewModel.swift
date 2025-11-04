import Foundation

struct DashboardViewModelActions {
    let showSupplements: () -> Void
    let showSettings: () -> Void
}

protocol DashboardViewModelInput {
    func viewDidLoad()
    func didTapSupplements()
    func didTapSettings()
    func didRefresh()
}

protocol DashboardViewModelOutput {
    var healthSummary: Observable<HealthSummary?> { get }
    var suggestions: Observable<[AISuggestion]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
}

protocol DashboardViewModel: DashboardViewModelInput, DashboardViewModelOutput {}

final class DefaultDashboardViewModel: DashboardViewModel {
    
    private let actions: DashboardViewModelActions
    
    let healthSummary: Observable<HealthSummary?> = Observable(nil)
    let suggestions: Observable<[AISuggestion]> = Observable([])
    let isLoading: Observable<Bool> = Observable(false)
    let error: Observable<String?> = Observable(nil)
    
    init(actions: DashboardViewModelActions) {
        self.actions = actions
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    func didRefresh() {
        loadData()
    }
    
    func didTapSupplements() {
        actions.showSupplements()
    }
    
    func didTapSettings() {
        actions.showSettings()
    }
    
    private func loadData() {
        // TODO: Load health summary and suggestions
        isLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading.value = false
        }
    }
}
