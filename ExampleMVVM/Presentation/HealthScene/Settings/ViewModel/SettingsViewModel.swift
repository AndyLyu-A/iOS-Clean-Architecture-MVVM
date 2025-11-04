import Foundation

struct SettingsViewModelActions {
    let didSignOut: () -> Void
}

protocol SettingsViewModelInput {
    func viewDidLoad()
    func didTapSignOut()
    func didTapRequestHealthKitAuthorization()
}

protocol SettingsViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
    var healthKitAuthorized: Observable<Bool> { get }
}

protocol SettingsViewModel: SettingsViewModelInput, SettingsViewModelOutput {}

final class DefaultSettingsViewModel: SettingsViewModel {
    
    private let actions: SettingsViewModelActions
    
    let isLoading: Observable<Bool> = Observable(false)
    let error: Observable<String?> = Observable(nil)
    let healthKitAuthorized: Observable<Bool> = Observable(false)
    
    init(actions: SettingsViewModelActions) {
        self.actions = actions
    }
    
    func viewDidLoad() {
        // TODO: Check HealthKit authorization status
    }
    
    func didTapSignOut() {
        // TODO: Sign out
        isLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading.value = false
            self?.actions.didSignOut()
        }
    }
    
    func didTapRequestHealthKitAuthorization() {
        // TODO: Request HealthKit authorization
        isLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading.value = false
            self?.healthKitAuthorized.value = true
        }
    }
}
