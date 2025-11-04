import UIKit

final class HealthDashboardViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet private var metricsTableView: UITableView!
    @IBOutlet private var permissionDeniedView: UIView!
    @IBOutlet private var permissionMessageLabel: UILabel!
    @IBOutlet private var openSettingsButton: UIButton!
    @IBOutlet private var requestPermissionButton: UIButton!
    @IBOutlet private var lastUpdatedLabel: UILabel!
    @IBOutlet private var emptyStateLabel: UILabel!
    
    private var viewModel: HealthDashboardViewModel!
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: HealthDashboardViewModel) -> HealthDashboardViewController {
        let view = HealthDashboardViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func setupViews() {
        title = viewModel.screenTitle
        
        metricsTableView.delegate = self
        metricsTableView.dataSource = self
        metricsTableView.register(HealthMetricCell.self, forCellReuseIdentifier: "HealthMetricCell")
        metricsTableView.tableFooterView = UIView()
        metricsTableView.rowHeight = UITableView.automaticDimension
        metricsTableView.estimatedRowHeight = 80
        
        permissionMessageLabel.text = viewModel.permissionDeniedMessage
        openSettingsButton.setTitle(NSLocalizedString("Open Settings", comment: ""), for: .normal)
        requestPermissionButton.setTitle(NSLocalizedString("Grant Permission", comment: ""), for: .normal)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        metricsTableView.refreshControl = refreshControl
    }
    
    private func bind(to viewModel: HealthDashboardViewModel) {
        viewModel.state.observe(on: self) { [weak self] state in
            self?.updateUI(for: state)
        }
        viewModel.healthSummary.observe(on: self) { [weak self] _ in
            self?.metricsTableView.reloadData()
        }
        viewModel.errorMessage.observe(on: self) { [weak self] message in
            self?.showError(message)
        }
        viewModel.lastUpdatedText.observe(on: self) { [weak self] text in
            self?.lastUpdatedLabel.text = text
        }
    }
    
    private func updateUI(for state: HealthDashboardState) {
        metricsTableView.refreshControl?.endRefreshing()
        
        switch state {
        case .initial:
            LoadingView.hide()
            permissionDeniedView.isHidden = false
            metricsTableView.isHidden = true
            lastUpdatedLabel.isHidden = true
            requestPermissionButton.isHidden = false
            openSettingsButton.isHidden = true
            emptyStateLabel.isHidden = true
            
        case .requestingPermission:
            LoadingView.show()
            permissionDeniedView.isHidden = true
            metricsTableView.isHidden = true
            lastUpdatedLabel.isHidden = true
            emptyStateLabel.isHidden = true
            
        case .permissionDenied:
            LoadingView.hide()
            permissionDeniedView.isHidden = false
            metricsTableView.isHidden = true
            lastUpdatedLabel.isHidden = true
            requestPermissionButton.isHidden = true
            openSettingsButton.isHidden = false
            emptyStateLabel.isHidden = true
            
        case .loading:
            LoadingView.show()
            permissionDeniedView.isHidden = true
            metricsTableView.isHidden = true
            lastUpdatedLabel.isHidden = true
            emptyStateLabel.isHidden = true
            
        case .loaded:
            LoadingView.hide()
            permissionDeniedView.isHidden = true
            
            if let summary = viewModel.healthSummary.value, !summary.isEmpty {
                metricsTableView.isHidden = false
                lastUpdatedLabel.isHidden = false
                emptyStateLabel.isHidden = true
            } else {
                metricsTableView.isHidden = true
                lastUpdatedLabel.isHidden = true
                emptyStateLabel.isHidden = false
                emptyStateLabel.text = NSLocalizedString("No health data available", comment: "")
            }
            
        case .error:
            LoadingView.hide()
            permissionDeniedView.isHidden = true
            metricsTableView.isHidden = true
            lastUpdatedLabel.isHidden = true
            emptyStateLabel.isHidden = true
        }
    }
    
    private func showError(_ message: String) {
        guard !message.isEmpty else { return }
        showAlert(
            title: NSLocalizedString("Error", comment: ""),
            message: message
        )
    }
    
    @objc private func handleRefresh() {
        viewModel.refreshData()
    }
    
    @IBAction private func requestPermissionTapped(_ sender: UIButton) {
        viewModel.requestPermission()
    }
    
    @IBAction private func openSettingsTapped(_ sender: UIButton) {
        viewModel.openSettings()
    }
}

// MARK: - UITableViewDataSource

extension HealthDashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let summary = viewModel.healthSummary.value else { return 0 }
        
        var count = 0
        if summary.steps != nil { count += 1 }
        if summary.heartRate != nil { count += 1 }
        if summary.sleep != nil { count += 1 }
        if summary.activeMinutes != nil { count += 1 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthMetricCell", for: indexPath) as! HealthMetricCell
        
        guard let summary = viewModel.healthSummary.value else { return cell }
        
        let metrics = [summary.steps, summary.heartRate, summary.sleep, summary.activeMinutes].compactMap { $0 }
        
        if indexPath.row < metrics.count {
            cell.configure(with: metrics[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HealthDashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - HealthMetricCell

class HealthMetricCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let iconLabel = UILabel()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        iconLabel.font = .systemFont(ofSize: 40)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconLabel)
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        valueLabel.font = .systemFont(ofSize: 28, weight: .bold)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with metric: HealthMetric) {
        switch metric.type {
        case .steps:
            titleLabel.text = NSLocalizedString("Steps", comment: "")
            iconLabel.text = "👟"
            valueLabel.text = String(format: "%.0f %@", metric.value, metric.unit)
        case .heartRate:
            titleLabel.text = NSLocalizedString("Heart Rate", comment: "")
            iconLabel.text = "❤️"
            valueLabel.text = String(format: "%.0f %@", metric.value, metric.unit)
        case .sleep:
            titleLabel.text = NSLocalizedString("Sleep", comment: "")
            iconLabel.text = "😴"
            valueLabel.text = String(format: "%.1f %@", metric.value, metric.unit)
        case .activeMinutes:
            titleLabel.text = NSLocalizedString("Active Minutes", comment: "")
            iconLabel.text = "🏃"
            valueLabel.text = String(format: "%.0f %@", metric.value, metric.unit)
        }
    }
}
