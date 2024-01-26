import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    
    let sectionTitle: [String] = ["Popular Movies"]
    var moviesArray: [ListMoviesResults] = []
    var seriesArray: [ListSeriesResults] = []
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.identifier)
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private lazy var headerView: MainPosterView = {
        let headerView = MainPosterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.75))
        headerView.randomButton.addTarget(self, action: #selector(randomButtonPressed), for: .touchUpInside)
        return headerView
    }()
    
    private lazy var segmentedControl: SegmentedControlView = {
        let tabBarHeight = tabBarController?.tabBar.frame.height
        let segmentedControlPositionY = UIScreen.main.bounds.height - tabBarHeight! - 35
        let segmentedControl = SegmentedControlView(frame: CGRect(x: 16, y: segmentedControlPositionY, width: view.bounds.width - 32, height: 30))
            segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
            return segmentedControl
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeFeedTable)
        view.addSubview(segmentedControl)
        view.addSubview(headerView.randomButton)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.contentInsetAdjustmentBehavior = .never
        homeFeedTable.tableHeaderView = headerView
        segmentedControlValueChanged()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        NSLayoutConstraint.activate ([
            headerView.randomButton.centerXAnchor.constraint(equalTo: segmentedControl.centerXAnchor),
            headerView.randomButton.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor),
            headerView.randomButton.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor)
        ])
    }
    
    @objc private func segmentedControlValueChanged() {
        fetchDataFromServer()
        homeFeedTable.reloadData()
        }
    
    @objc private func randomButtonPressed() {
        if segmentedControl.selectedSegmentIndex == 0 {
            if let randomMovie = moviesArray.randomElement() {
                headerView.configureMovieHeader(with: randomMovie)
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if let randomSeries = seriesArray.randomElement() {
                headerView.configureSeriesHeader(with: randomSeries)
            }
        }
    }
    
    private func fetchDataFromServer() {
        if segmentedControl.selectedSegmentIndex == 0 {
            fetchMoviesFromServer()
        } else if segmentedControl.selectedSegmentIndex == 1 {
            fetchSeriesFromServer()
        }
    }
    
    private func fetchMoviesFromServer() {
        let requestURL = "https://api.themoviedb.org/3/movie/popular?api_key=906f4bd102dba0809de8ac6e45137f9a"
        
        AF.request(requestURL).responseDecodable(of: ListMovies.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let listMovies):
                self.moviesArray = listMovies.results ?? []
                if let randomElement = self.moviesArray.randomElement() {
                    self.headerView.configureMovieHeader(with: randomElement)
                }
                DispatchQueue.main.async {
                    self.homeFeedTable.reloadData()
                }
            case .failure(let error):
                print("Alamofire request failed: \(error)")
            }
        }
    }
    
    private func fetchSeriesFromServer() {
        let requestURL = "https://api.themoviedb.org/3/tv/popular?api_key=906f4bd102dba0809de8ac6e45137f9a"
        
        AF.request(requestURL).responseDecodable(of: ListSeries.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let listSeries):
                self.seriesArray = listSeries.results ?? []
                if let randomElement = self.seriesArray.randomElement() {
                    self.headerView.configureSeriesHeader(with: randomElement)
                }
                DispatchQueue.main.async {
                    self.homeFeedTable.reloadData()
                }
            case .failure(let error):
                print("Alamofire request failed: \(error)")
            }
        }
    }
}

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
            cell.configure(with: moviesArray, segmentedControl: segmentedControl)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            cell.configure(with: seriesArray, segmentedControl: segmentedControl)
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
