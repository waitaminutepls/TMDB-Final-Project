import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = SearchViewModel()
    
    // MARK: - UI Elements
    
    private lazy var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 7.5, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "Search..."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's find something interesting..."
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Configuration
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        view.addSubview(noResultLabel)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        NSLayoutConstraint.activate([
            searchResultsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchResultsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noResultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            noResultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    // MARK: - Methods
    
    private func fetchDataFromServer(with searchText: String) {
        viewModel.fetchSearchFromServer(with: searchText) { [weak self] results in
            guard let self = self else { return }
            self.viewModel.updateSearchResults(results)
            self.searchResultsCollectionView.reloadData()
            self.showNoResultsLabel(for: searchText)
        }
    }
    
    private func showNoResultsLabel(for searchText: String) {
        noResultLabel.isHidden = !(viewModel.searchArray.isEmpty || searchText.isEmpty)
        noResultLabel.text = searchText.isEmpty ? "Let's find something interesting..." : "Nothing was found for the request '\(searchText)'"
    }
}

// MARK: - Extensions

extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            fetchDataFromServer(with: searchText)
        } else {
            viewModel.updateSearchResults([])
            DispatchQueue.main.async {
                self.searchResultsCollectionView.reloadData()
                self.showNoResultsLabel(for: "")
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        let searchResult = viewModel.searchArray[indexPath.row]
        cell.configureSearchPoster(with: searchResult)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchArray.count
    }
}
