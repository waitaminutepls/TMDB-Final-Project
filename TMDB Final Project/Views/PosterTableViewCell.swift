import UIKit

class PosterTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "PosterTableViewCell"
    private var viewModel: HomeViewModel?
    private var addClosure: (() -> Void)?
    var segmentedControl: UISegmentedControl?
    var didSelectItemHandler: ((Int?) -> Void)?

    // MARK: - UI Elements
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemSizeWidth = UIScreen.main.bounds.width / 2.5
        let itemSizeHeight = UIScreen.main.bounds.height / 3.75
        layout.itemSize = CGSize(width: itemSizeWidth, height: itemSizeHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 7.5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        setupCollectionView()
    }
    
    // MARK: - Required Initialization
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - Methods
    
    private func setupCollectionView() {
         contentView.addSubview(collectionView)
         collectionView.delegate = self
         collectionView.dataSource = self
     }
    
    public func configure(with items: [Any], viewModel: HomeViewModel, segmentedControl: UISegmentedControl) {
        self.viewModel = viewModel
        
        if let moviesArray = items as? [ListMoviesResults] {
            self.viewModel?.moviesArray = moviesArray
        } else if let seriesArray = items as? [ListSeriesResults] {
            self.viewModel?.seriesArray = seriesArray
        }
        self.segmentedControl = segmentedControl
        collectionView.reloadData()
    }
}

// MARK: - Extensions PosterTableViewCell

extension PosterTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl?.selectedSegmentIndex {
        case 0:
            return viewModel?.moviesArray.count ?? 0
        case 1:
            return viewModel?.seriesArray.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch segmentedControl?.selectedSegmentIndex {
        case 0:
            if let movie = viewModel?.moviesArray[indexPath.row] {
                cell.configureMoviePoster(with: movie)
            }
            cell.setItemClosure {
                let movieResult = self.viewModel?.moviesArray[indexPath.row]
                guard let itemId = movieResult?.id,
                      let title = movieResult?.title,
                      let posterURL = movieResult?.posterPath,
                      let overview = movieResult?.overview
                else { return }
                RealmManager.shared.addWatchLaterItem(addId: itemId, addTitle: title, addPosterURL: posterURL, addOverview: overview, addIsMovie: true)
            }
        case 1:
            if let tvShow = viewModel?.seriesArray[indexPath.row] {
                cell.configureSeriesPoster(with: tvShow)
            }
            cell.setItemClosure {
                let seriesResult = self.viewModel?.seriesArray[indexPath.row]
                guard let itemId = seriesResult?.id,
                      let title = seriesResult?.name,
                      let posterURL = seriesResult?.posterPath,
                      let overview = seriesResult?.overview
                else { return }
                RealmManager.shared.addWatchLaterItem(addId: itemId, addTitle: title, addPosterURL: posterURL, addOverview: overview, addIsMovie: false)
                NotificationCenter.default.post(name: .itemAddedToWatchList, object: nil)
            }
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch segmentedControl?.selectedSegmentIndex {
        case 0:
            let selectedMovie = viewModel?.moviesArray[indexPath.item]
            let itemId = selectedMovie?.id
            didSelectItemHandler?(itemId)
        case 1:
            let selectedShow = viewModel?.seriesArray[indexPath.item]
            let itemId = selectedShow?.id
            didSelectItemHandler?(itemId)
        default:
            break
        }
    }
}

extension Notification.Name {
    static let itemAddedToWatchList = Notification.Name("ItemAddedToWatchList")
}
