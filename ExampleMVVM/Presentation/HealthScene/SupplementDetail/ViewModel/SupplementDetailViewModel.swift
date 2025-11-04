import Foundation

struct SupplementDetailViewModelActions {
    let didSaveSupplement: (Supplement) -> Void
    let didDeleteSupplement: () -> Void
}

protocol SupplementDetailViewModelInput {
    func viewDidLoad()
    func didTapSave(name: String, type: SupplementType, amount: Double, unit: String, frequency: String)
    func didTapDelete()
}

protocol SupplementDetailViewModelOutput {
    var supplement: Supplement? { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
}

protocol SupplementDetailViewModel: SupplementDetailViewModelInput, SupplementDetailViewModelOutput {}

final class DefaultSupplementDetailViewModel: SupplementDetailViewModel {
    
    private let actions: SupplementDetailViewModelActions
    let supplement: Supplement?
    
    let isLoading: Observable<Bool> = Observable(false)
    let error: Observable<String?> = Observable(nil)
    
    init(supplement: Supplement?, actions: SupplementDetailViewModelActions) {
        self.supplement = supplement
        self.actions = actions
    }
    
    func viewDidLoad() {
        // Nothing to do here yet
    }
    
    func didTapSave(name: String, type: SupplementType, amount: Double, unit: String, frequency: String) {
        // TODO: Validate and save supplement
        isLoading.value = true
        
        let dosage = SupplementDosage(amount: amount, unit: unit, frequency: frequency, timeOfDay: [])
        let now = Date()
        let newSupplement = Supplement(
            id: supplement?.id ?? UUID().uuidString,
            name: name,
            type: type,
            dosage: dosage,
            startDate: supplement?.startDate ?? now,
            endDate: nil,
            notes: nil,
            isActive: true,
            createdAt: supplement?.createdAt ?? now,
            updatedAt: now
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading.value = false
            self?.actions.didSaveSupplement(newSupplement)
        }
    }
    
    func didTapDelete() {
        guard supplement != nil else { return }
        // TODO: Delete supplement
        isLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading.value = false
            self?.actions.didDeleteSupplement()
        }
    }
}
