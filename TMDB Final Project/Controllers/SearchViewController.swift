import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    let tableView = UITableView()
    let searchBar = UISearchBar()
    let noResultLabel = UILabel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var searchTimer: Timer?
    var searchResults: SearchMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchBar()
        setupTableView()
        setupLabel()
        
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupLabel() {
        noResultLabel.text = "Enter your request..."
        noResultLabel.textColor = .systemGray
        noResultLabel.textAlignment = .center
        noResultLabel.numberOfLines = 0
        tableView.addSubview(noResultLabel)
        
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noResultLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            noResultLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            noResultLabel.leadingAnchor.constraint(greaterThanOrEqualTo: tableView.leadingAnchor, constant: 16),
            noResultLabel.trailingAnchor.constraint(lessThanOrEqualTo: tableView.trailingAnchor, constant: -16)
        ])
    }
    
    func performSearch(with searchText: String) {
        guard !searchText.isEmpty else { return }
        
        let apiKey = "906f4bd102dba0809de8ac6e45137f9a"
        let baseURL = "https://api.themoviedb.org/3/search/movie?"
        let parameters: [String: Any] = ["api_key": apiKey, "query": searchText]
        
        AF.request(baseURL, parameters: parameters).responseDecodable(of: SearchMovie.self) {
            response in
            switch response.result {
            case .success(let allData):
                self.searchResults = allData
                self.tableView.reloadData()
                self.showNoResultsLabel(for: searchText)
            case .failure(let error):
                print("Alamofire request failed: \(error)")
            }
        }
    }
    
    func showNoResultsLabel(for searchText: String) {
        if searchResults?.results?.isEmpty == true || searchText.isEmpty {
            noResultLabel.isHidden = false
            noResultLabel.text = searchText.isEmpty ? "Enter your request..." : "Nothing was found for the request ''\(searchText)''"
        } else {
            noResultLabel.isHidden = true
        }
    }
    
}


extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResultsCount = searchResults?.results?.count {
            return searchResultsCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let searchResult = searchResults?.results?[indexPath.row] {
            cell.textLabel?.text = searchResult.title
        }
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        if searchText.isEmpty {
            searchResults = nil
            tableView.reloadData()
        }
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] _ in
            DispatchQueue.global(qos: .default).async {
                self?.performSearch(with: searchText)
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty && range.length > 0 {
            searchTimer?.invalidate()
            searchResults = nil
            tableView.reloadData()
            showNoResultsLabel(for: "")
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            performSearch(with: searchText)
            searchBar.resignFirstResponder()
        }
    }
    
    private func searchBarCancelButtonClicked(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
}
