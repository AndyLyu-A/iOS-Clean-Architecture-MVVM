import UIKit

final class DashboardViewController: UIViewController, StoryboardInstantiable {
    
    private var viewModel: DashboardViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    static func create(with viewModel: DashboardViewModel) -> DashboardViewController {
        let viewController = DashboardViewController.instantiateViewController()
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
        title = "Dashboard"
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped)),
            UIBarButtonItem(title: "Supplements", style: .plain, target: self, action: #selector(supplementsTapped))
        ]
        
        tableView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func bind(to viewModel: DashboardViewModel) {
        viewModel.isLoading.observe(on: self) { [weak self] isLoading in
            if !isLoading {
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.healthSummary.observe(on: self) { [weak self] _ in
            self?.tableView?.reloadData()
        }
        
        viewModel.suggestions.observe(on: self) { [weak self] _ in
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
    
    @objc private func supplementsTapped() {
        viewModel.didTapSupplements()
    }
    
    @objc private func settingsTapped() {
        viewModel.didTapSettings()
    }
    
    deinit {
        viewModel.isLoading.remove(observer: self)
        viewModel.healthSummary.remove(observer: self)
        viewModel.suggestions.remove(observer: self)
        viewModel.error.remove(observer: self)
    }
}

extension DashboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Dashboard - Coming Soon"
        return cell
    }
}

extension DashboardViewController: Alertable {}
