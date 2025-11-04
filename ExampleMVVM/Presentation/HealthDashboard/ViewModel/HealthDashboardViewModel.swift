import Foundation

struct HealthDashboardViewModelActions {
    let openSettings: () -> Void
}

enum HealthDashboardState {
    case initial
    case requestingPermission
    case permissionDenied
    case loading
    case loaded
    case error
}

protocol HealthDashboardViewModelInput {
    func viewDidLoad()
    func requestPermission()
    func refreshData()
    func openSettings()
}

protocol HealthDashboardViewModelOutput {
    var state: Observable<HealthDashboardState> { get }
    var healthSummary: Observable<HealthSummary?> { get }
    var errorMessage: Observable<String> { get }
    var lastUpdatedText: Observable<String> { get }
    
    var screenTitle: String { get }
    var permissionDeniedMessage: String { get }
    var loadingMessage: String { get }
}

typealias HealthDashboardViewModel = HealthDashboardViewModelInput & HealthDashboardViewModelOutput

final class DefaultHealthDashboardViewModel: HealthDashboardViewModel {
    
    private let requestAuthorizationUseCase: RequestHealthAuthorizationUseCase
    private let fetchHealthSummaryUseCase: FetchHealthSummaryUseCase
    private let actions: HealthDashboardViewModelActions?
    private let mainQueue: DispatchQueueType
    
    // MARK: - OUTPUT
    
    let state: Observable<HealthDashboardState> = Observable(.initial)
    let healthSummary: Observable<HealthSummary?> = Observable(nil)
    let errorMessage: Observable<String> = Observable("")
    let lastUpdatedText: Observable<String> = Observable("")
    
    let screenTitle = NSLocalizedString("Health Dashboard", comment: "")
    let permissionDeniedMessage = NSLocalizedString(
        "This app requires access to your health data. Please enable HealthKit access in Settings.",
        comment: ""
    )
    let loadingMessage = NSLocalizedString("Loading health data...", comment: "")
    
    // MARK: - Init
    
    init(
        requestAuthorizationUseCase: RequestHealthAuthorizationUseCase,
        fetchHealthSummaryUseCase: FetchHealthSummaryUseCase,
        actions: HealthDashboardViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.requestAuthorizationUseCase = requestAuthorizationUseCase
        self.fetchHealthSummaryUseCase = fetchHealthSummaryUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }
    
    // MARK: - Private
    
    private func updateLastUpdatedText() {
        guard let summary = healthSummary.value else {
            lastUpdatedText.value = ""
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        lastUpdatedText.value = String(
            format: NSLocalizedString("Last updated: %@", comment: ""),
            formatter.string(from: summary.lastUpdated)
        )
    }
    
    private func handleAuthorizationResult(_ result: Result<HealthAuthorizationStatus, Error>) {
        mainQueue.async { [weak self] in
            switch result {
            case .success(let status):
                switch status {
                case .authorized:
                    self?.loadHealthData()
                case .denied:
                    self?.state.value = .permissionDenied
                case .notDetermined:
                    self?.state.value = .initial
                }
            case .failure(let error):
                self?.state.value = .error
                self?.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    private func loadHealthData() {
        state.value = .loading
        
        fetchHealthSummaryUseCase.execute { [weak self] result in
            self?.mainQueue.async {
                switch result {
                case .success(let summary):
                    self?.healthSummary.value = summary
                    self?.state.value = .loaded
                    self?.updateLastUpdatedText()
                case .failure(let error):
                    self?.state.value = .error
                    self?.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - INPUT. View event methods

extension DefaultHealthDashboardViewModel {
    
    func viewDidLoad() {
        requestAuthorizationUseCase.execute { [weak self] result in
            self?.handleAuthorizationResult(result)
        }
    }
    
    func requestPermission() {
        state.value = .requestingPermission
        requestAuthorizationUseCase.execute { [weak self] result in
            self?.handleAuthorizationResult(result)
        }
    }
    
    func refreshData() {
        loadHealthData()
    }
    
    func openSettings() {
        actions?.openSettings()
    }
}
