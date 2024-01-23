import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    
    let sectionTitle: [String] = ["Popular Movies"]
    var moviesArray: [ListMoviesResults] = []
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    private lazy var headerView: MainPosterView = {
            let headerView = MainPosterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
            headerView.randomButton.addTarget(self, action: #selector(randomButtonPressed), for: .touchUpInside)
            return headerView
        }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.contentInsetAdjustmentBehavior = .never
        homeFeedTable.tableHeaderView = headerView
        fetchMoviesFromServer()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    @objc private func randomButtonPressed() {
        if let randomMovie = moviesArray.randomElement() {
            headerView.configure(with: randomMovie)
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
                    self.headerView.configure(with: randomElement)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: moviesArray)
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
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: tableView.bounds.width, height: header.bounds.height)
        header.textLabel?.backgroundColor = .red
        header.textLabel?.textColor = .white
        header.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
}
