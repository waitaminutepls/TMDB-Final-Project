import UIKit
import Alamofire

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var moviesArray: [ListMoviesResults] = []
    var seriesArray: [ListSeriesResults] = []
    
    
    let basePosterPathURL = "https://image.tmdb.org/t/p/w500"
    let segmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUperCollectionView()
        setupSegmetedControl()
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 1
        fetchDataForSelectedSegment()
    }
    
    @objc private func segmentedControlValueChanged() {
        fetchDataForSelectedSegment()
        collectionView.reloadData()
        DispatchQueue.main.async {
                let indexPath = IndexPath(item: 0, section: 0)
                if self.collectionView.numberOfItems(inSection: indexPath.section) > 0 {
                    self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                }
            }
    }
    
    private func fetchDataForSelectedSegment() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        if selectedIndex == 0 {
            let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=906f4bd102dba0809de8ac6e45137f9a"
            fetchMoviesFromServer(requestURL: popularMoviesURL)
        } else if selectedIndex == 1 {
            let popularSeriesURL = "https://api.themoviedb.org/3/tv/popular?api_key=906f4bd102dba0809de8ac6e45137f9a"
            fetchSeriesFromServer(requestURL: popularSeriesURL)
        }
    }
    
    private func fetchMoviesFromServer(requestURL: String) {
        AF.request(requestURL).responseDecodable(of: ListMovies.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let listMovies):
                self.moviesArray = listMovies.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Alamofire request failed: \(error)")
            }
        }
    }
    
    private func fetchSeriesFromServer(requestURL: String) {
        AF.request(requestURL).responseDecodable(of: ListSeries.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let listSeries):
                self.seriesArray = listSeries.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Alamofire request failed: \(error)")
            }
        }
    }
    
    private func setupSegmetedControl() {
        segmentedControl.insertSegment(withTitle: "Movies", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "TV Shows", at: 1, animated: true)
        view.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
        ])
    }
    
    private func setupUperCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(UpperCollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return min(moviesArray.count, 5)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return min(seriesArray.count, 5)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! UpperCollectionViewCell
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let movie = moviesArray[indexPath.item]
            cell.configure(with: movie.posterPath, baseURL: basePosterPathURL)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let tvShows = seriesArray[indexPath.item]
            cell.configure(with: tvShows.posterPath, baseURL: basePosterPathURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.bounds.width
        let cellHeight = view.bounds.height / 2
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
