import UIKit

final class SupplementDetailViewController: UIViewController, StoryboardInstantiable {
    
    private var viewModel: SupplementDetailViewModel!
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var unitTextField: UITextField!
    @IBOutlet private weak var frequencyTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    
    static func create(with viewModel: SupplementDetailViewModel) -> SupplementDetailViewController {
        let viewController = SupplementDetailViewController.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func setupViews() {
        title = viewModel.supplement == nil ? "Add Supplement" : "Edit Supplement"
        
        if let supplement = viewModel.supplement {
            nameTextField?.text = supplement.name
            amountTextField?.text = "\(supplement.dosage.amount)"
            unitTextField?.text = supplement.dosage.unit
            frequencyTextField?.text = supplement.dosage.frequency
            deleteButton?.isHidden = false
        } else {
            deleteButton?.isHidden = true
        }
        
        saveButton?.setTitle("Save", for: .normal)
        deleteButton?.setTitle("Delete", for: .normal)
    }
    
    private func bind(to viewModel: SupplementDetailViewModel) {
        viewModel.isLoading.observe(on: self) { [weak self] isLoading in
            self?.saveButton?.isEnabled = !isLoading
            self?.deleteButton?.isEnabled = !isLoading
        }
        
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        let name = nameTextField?.text ?? ""
        let type = SupplementType.vitamin
        let amount = Double(amountTextField?.text ?? "0") ?? 0
        let unit = unitTextField?.text ?? ""
        let frequency = frequencyTextField?.text ?? ""
        
        viewModel.didTapSave(name: name, type: type, amount: amount, unit: unit, frequency: frequency)
    }
    
    @IBAction private func deleteButtonTapped(_ sender: UIButton) {
        viewModel.didTapDelete()
    }
    
    deinit {
        viewModel.isLoading.remove(observer: self)
        viewModel.error.remove(observer: self)
    }
}

extension SupplementDetailViewController: Alertable {}
