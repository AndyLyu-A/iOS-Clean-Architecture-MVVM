import UIKit

final class SettingsViewController: UIViewController, StoryboardInstantiable {
    
    private var viewModel: SettingsViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private enum SettingsItem {
        case healthKitAuthorization
        case signOut
    }
    
    private let items: [SettingsItem] = [.healthKitAuthorization, .signOut]
    
    static func create(with viewModel: SettingsViewModel) -> SettingsViewController {
        let viewController = SettingsViewController.instantiateViewController()
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
        title = "Settings"
    }
    
    private func bind(to viewModel: SettingsViewModel) {
        viewModel.healthKitAuthorized.observe(on: self) { [weak self] _ in
            self?.tableView?.reloadData()
        }
        
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }
    }
    
    deinit {
        viewModel.healthKitAuthorized.remove(observer: self)
        viewModel.error.remove(observer: self)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        let item = items[indexPath.row]
        
        switch item {
        case .healthKitAuthorization:
            cell.textLabel?.text = "HealthKit Authorization"
            cell.detailTextLabel?.text = viewModel.healthKitAuthorized.value ? "Authorized" : "Not Authorized"
        case .signOut:
            cell.textLabel?.text = "Sign Out"
            cell.textLabel?.textColor = .red
        }
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        
        switch item {
        case .healthKitAuthorization:
            viewModel.didTapRequestHealthKitAuthorization()
        case .signOut:
            viewModel.didTapSignOut()
        }
    }
}

extension SettingsViewController: Alertable {}
