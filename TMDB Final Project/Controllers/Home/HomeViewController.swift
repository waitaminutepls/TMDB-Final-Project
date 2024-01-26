import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = HomeViewModel()
    private let sectionTitle: [String] = ["Popular Movies"]
    
    // MARK: - UI Elements
    
    private lazy var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.identifier)
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Movies", "TV Shows"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.isOpaque = true
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var headerView: PosterHeaderView = {
        let headerView = PosterHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.75))
        headerView.randomButton.addTarget(self, action: #selector(randomButtonPressed), for: .touchUpInside)
        return headerView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        fetchDataFromServer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    // MARK: - Configuration
    
    private func configureSubviews() {
        view.addSubview(homeFeedTable)
        view.addSubview(segmentedControl)
        view.addSubview(headerView.randomButton)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.contentInsetAdjustmentBehavior = .never
        homeFeedTable.tableHeaderView = headerView
        segmentedControlValueChanged()
    }
    
    private func configureLayout() {
        let tabBarHeight = tabBarController?.tabBar.frame.height
        let segmentedControlPositionY = UIScreen.main.bounds.height - tabBarHeight! - 35
        homeFeedTable.frame = view.bounds
        segmentedControl.frame = CGRect(x: 16, y: segmentedControlPositionY, width: view.bounds.width - 32, height: 30)
        NSLayoutConstraint.activate ([
            headerView.randomButton.centerXAnchor.constraint(equalTo: segmentedControl.centerXAnchor),
            headerView.randomButton.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor),
            headerView.randomButton.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor)
        ])
    }
    
    // MARK: - Methods
    
    @objc private func segmentedControlValueChanged() {
        fetchDataFromServer()
        homeFeedTable.reloadData()
    }
    
    @objc private func randomButtonPressed() {
        if segmentedControl.selectedSegmentIndex == 0 {
            if let randomMovie = self.viewModel.moviesArray.randomElement() {
                self.headerView.configureMovieHeader(with: randomMovie)
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if let randomShow = self.viewModel.seriesArray.randomElement() {
                self.headerView.configureSeriesHeader(with: randomShow)
            }
        }
    }
    
    private func fetchDataFromServer() {
        if segmentedControl.selectedSegmentIndex == 0 {
            viewModel.fetchMoviesFromServer { [weak self] results in
                guard let self = self else { return }
                self.viewModel.updateSearchMovieResults(results)
                if let randomMovie = self.viewModel.moviesArray.randomElement() {
                    self.headerView.configureMovieHeader(with: randomMovie)
                }
                self.homeFeedTable.reloadData()
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            viewModel.fetchSeriesFromServer { [weak self] results in
                guard let self = self else { return }
                self.viewModel.updateSearchShowResults(results)
                if let randomShow = self.viewModel.seriesArray.randomElement() {
                    self.headerView.configureSeriesHeader(with: randomShow)
                }
                self.homeFeedTable.reloadData()
            }
        }
    }
}

// MARK: - Extensions

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.identifier, for: indexPath) as? PosterTableViewCell else {
            return UITableViewCell()
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.configure(with: viewModel.moviesArray, viewModel: viewModel, segmentedControl: segmentedControl)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            cell.configure(with: viewModel.seriesArray, viewModel: viewModel, segmentedControl: segmentedControl)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        header.textLabel?.frame = CGRect(x: header.bounds.minX, y: header.bounds.origin.y, width: tableView.bounds.width, height: header.bounds.height)
        header.textLabel?.backgroundColor = .yellow
        header.textLabel?.textColor = .black
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
}
