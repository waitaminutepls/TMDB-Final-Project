import UIKit
import RealmSwift

class WatchLaterViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = WatchLaterViewModel()
    
    // MARK: - UI Elements
    
    private let watchLaterTable: UITableView = {
        let table = UITableView()
        table.register(WatchLaterTableViewCell.self, forCellReuseIdentifier: WatchLaterTableViewCell.identifier)
        table.backgroundColor = .systemBackground
        return table
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        observeViewModelChanges()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        watchLaterTable.frame = view.bounds
    }
    
    // MARK: - Configuration
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(watchLaterTable)
        watchLaterTable.delegate = self
        watchLaterTable.dataSource = self
    }
    
    private func configureNavigationBar() {
        title = "Watch Later"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func observeViewModelChanges() {
            viewModel.delegate = self
            viewModel.observeRealmChanges()
        }
}

// MARK: - Extensions WatchLaterViewController Delegate/DataSource

extension WatchLaterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfWatchLaterItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchLaterTableViewCell.identifier, for: indexPath) as? WatchLaterTableViewCell,
              let watchLaterItem = viewModel.getWatchLaterItem(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configure(with: watchLaterItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.frame.height / 4
        return height
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            self.viewModel.deleteWatchLaterItem(at: indexPath.row)
            completionHandler(true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let watchLaterItem = viewModel.getWatchLaterItem(at: indexPath.row) else { return }
        SafariController.openWatchLaterSafariController(with: watchLaterItem, from: self)
    }
}

// MARK: - Extensions WatchLaterViewController ViewModelDelegate


extension WatchLaterViewController: WatchLaterViewModelDelegate {
    func didUpdateWatchLaterItems() {
        watchLaterTable.reloadData()
    }
}
