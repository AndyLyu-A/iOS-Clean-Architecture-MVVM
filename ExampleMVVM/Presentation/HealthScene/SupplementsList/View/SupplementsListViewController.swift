import UIKit

final class SupplementsListViewController: UIViewController, StoryboardInstantiable {
    
    private var viewModel: SupplementsListViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    static func create(with viewModel: SupplementsListViewModel) -> SupplementsListViewController {
        let viewController = SupplementsListViewController.instantiateViewController()
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
        title = "Supplements"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        
        tableView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func bind(to viewModel: SupplementsListViewModel) {
        viewModel.isLoading.observe(on: self) { [weak self] isLoading in
            if !isLoading {
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.supplements.observe(on: self) { [weak self] _ in
            self?.tableView?.reloadData()
        }
        
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }
    }
    
    @objc private func refresh() {
        viewModel.didRefresh()
    }
    
    @objc private func addTapped() {
        viewModel.didTapAddSupplement()
    }
    
    deinit {
        viewModel.isLoading.remove(observer: self)
        viewModel.supplements.remove(observer: self)
        viewModel.error.remove(observer: self)
    }
}

extension SupplementsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.supplements.value.count
        return count > 0 ? count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let supplements = viewModel.supplements.value
        if supplements.isEmpty {
            cell.textLabel?.text = "No supplements yet"
            cell.detailTextLabel?.text = "Tap + to add your first supplement"
        } else {
            let supplement = supplements[indexPath.row]
            cell.textLabel?.text = supplement.name
            cell.detailTextLabel?.text = "\(supplement.dosage.amount) \(supplement.dosage.unit)"
        }
        
        return cell
    }
}

extension SupplementsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !viewModel.supplements.value.isEmpty {
            viewModel.didSelectSupplement(at: indexPath.row)
        }
    }
}

extension SupplementsListViewController: Alertable {}
