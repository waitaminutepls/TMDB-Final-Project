import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = HomeViewModel()
    private let sectionTitle: [String] = ["Popular"]
    
    // MARK: - UI Elements
    
    private lazy var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.identifier)
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private lazy var headerView: PosterHeaderView = {
        let headerView = PosterHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.75))
        headerView.randomButton.addTarget(self, action: #selector(randomButtonPressed), for: .touchUpInside)
        headerView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
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
        view.addSubview(headerView.segmentedControl)
        view.addSubview(headerView.randomButton)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.contentInsetAdjustmentBehavior = .never
        homeFeedTable.tableHeaderView = headerView
        segmentedControlValueChanged()
        
        let headerTapGesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
        headerView.addGestureRecognizer(headerTapGesture)
    }
    
    private func configureLayout() {
        headerView.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        homeFeedTable.frame = view.bounds
        NSLayoutConstraint.activate ([
            headerView.randomButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            headerView.randomButton.centerXAnchor.constraint(equalTo: homeFeedTable.centerXAnchor),
            
            headerView.segmentedControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            headerView.segmentedControl.leadingAnchor.constraint(equalTo: headerView.randomButton.trailingAnchor, constant: 5),
            headerView.segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
    }
    
    // MARK: - Methods
    
    @objc private func segmentedControlValueChanged() {
        fetchDataFromServer()
        homeFeedTable.reloadData()
    }
    
    @objc private func randomButtonPressed() {
        switch headerView.segmentedControl.selectedSegmentIndex {
        case 0:
            if let randomMovie = self.viewModel.moviesArray.randomElement() {
                self.headerView.configureMovieHeader(with: randomMovie)
            }
        case 1:
            if let randomShow = self.viewModel.seriesArray.randomElement() {
                self.headerView.configureSeriesHeader(with: randomShow)
            }
        default:
            break
        }
    }
    
    @objc private func headerViewTapped() {
        guard let itemId = headerView.currentItemId else { return }
        switch headerView.segmentedControl.selectedSegmentIndex {
        case 0:
            SafariController.openSafariController(with: itemId, isMovie: true, from: self)
        case 1:
            SafariController.openSafariController(with: itemId, isMovie: false, from: self)
        default:
            break
        }
    }
    
    private func fetchDataFromServer() {
        switch headerView.segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.fetchMoviesFromServer { [weak self] results in
                guard let self = self else { return }
                self.viewModel.updateSearchMovieResults(results)
                if let randomMovie = self.viewModel.moviesArray.randomElement() {
                    self.headerView.configureMovieHeader(with: randomMovie)
                    self.headerView.currentItemId = randomMovie.id
                }
                self.homeFeedTable.reloadData()
            }
        case 1:
            viewModel.fetchSeriesFromServer { [weak self] results in
                guard let self = self else { return }
                self.viewModel.updateSearchShowResults(results)
                if let randomShow = self.viewModel.seriesArray.randomElement() {
                    self.headerView.configureSeriesHeader(with: randomShow)
                    self.headerView.currentItemId = randomShow.id
                }
                self.homeFeedTable.reloadData()
            }
        default:
            break
        }
    }
    
    private func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    private func setupLetterColor(for header: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: header)
        for (index, _) in header.enumerated() {
            let color = randomColor()
            let range = NSMakeRange(index, 1)
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        return  attributedString
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
        switch headerView.segmentedControl.selectedSegmentIndex {
        case 0:
            cell.configure(with: viewModel.moviesArray, viewModel: viewModel, segmentedControl: headerView.segmentedControl)
            cell.didSelectItemHandler = { [weak self] itemId in
                SafariController.openSafariController(with: itemId, isMovie: true, from: self ?? UIViewController())
            }
        case 1:
            cell.configure(with: viewModel.seriesArray, viewModel: viewModel, segmentedControl: headerView.segmentedControl)
            cell.didSelectItemHandler = { [weak self] itemId in
                SafariController.openSafariController(with: itemId, isMovie: false, from: self ?? UIViewController())
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 3.75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        let labelText = header.textLabel?.text ?? ""
        let attributedString = setupLetterColor(for: labelText)
        header.textLabel?.attributedText = attributedString
        header.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 25)
        header.textLabel?.textAlignment = .center
        header.textLabel?.baselineAdjustment = .alignCenters
        header.frame = CGRect(x: header.bounds.minX, y: header.bounds.origin.y, width: tableView.bounds.width, height: header.bounds.height)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
}
