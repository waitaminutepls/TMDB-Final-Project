import UIKit

class PosterTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "PosterTableViewCell"
    private var viewModel: HomeViewModel?
    var segmentedControl: UISegmentedControl?
    var didSelectItemHandler: ((Int?) -> Void)?
    
    // MARK: - UI Elements
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 , height: UIScreen.main.bounds.height / 3.75)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    public func configure(with items: [Any], viewModel: HomeViewModel, segmentedControl: UISegmentedControl) {
        self.viewModel = viewModel
        
        if let moviesArray = items as? [ListMoviesResults] {
            self.viewModel?.moviesArray = moviesArray
        } else if let seriesArray = items as? [ListSeriesResults] {
            self.viewModel?.seriesArray = seriesArray
        }
        
        self.segmentedControl = segmentedControl
        self.collectionView.reloadData()
    }
}

// MARK: - Extensions

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
        case 1:
            if let tvShow = viewModel?.seriesArray[indexPath.row] {
                cell.configureSeriesPoster(with: tvShow)
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
