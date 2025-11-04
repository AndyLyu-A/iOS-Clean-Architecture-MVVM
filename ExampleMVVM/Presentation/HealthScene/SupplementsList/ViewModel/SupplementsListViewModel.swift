import Foundation

struct SupplementsListViewModelActions {
    let showSupplementDetail: (Supplement?) -> Void
    let didUpdateSupplements: () -> Void
}

protocol SupplementsListViewModelInput {
    func viewDidLoad()
    func didSelectSupplement(at index: Int)
    func didTapAddSupplement()
    func didRefresh()
}

protocol SupplementsListViewModelOutput {
    var supplements: Observable<[Supplement]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
}

protocol SupplementsListViewModel: SupplementsListViewModelInput, SupplementsListViewModelOutput {}

final class DefaultSupplementsListViewModel: SupplementsListViewModel {
    
    private let actions: SupplementsListViewModelActions
    
    let supplements: Observable<[Supplement]> = Observable([])
    let isLoading: Observable<Bool> = Observable(false)
    let error: Observable<String?> = Observable(nil)
    
    init(actions: SupplementsListViewModelActions) {
        self.actions = actions
    }
    
    func viewDidLoad() {
        loadSupplements()
    }
    
    func didRefresh() {
        loadSupplements()
    }
    
    func didSelectSupplement(at index: Int) {
        guard index < supplements.value.count else { return }
        let supplement = supplements.value[index]
        actions.showSupplementDetail(supplement)
    }
    
    func didTapAddSupplement() {
        actions.showSupplementDetail(nil)
    }
    
    private func loadSupplements() {
        // TODO: Load supplements from repository
        isLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading.value = false
            self?.supplements.value = []
        }
    }
}
