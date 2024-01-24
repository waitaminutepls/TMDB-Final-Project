import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    private var listMovies: [ListMoviesResults] = [ListMoviesResults]()
    private var listSeries: [ListSeriesResults] = [ListSeriesResults]()
    var segmentedControl: SegmentedControlView?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with listMovies: [ListMoviesResults], segmentedControl: SegmentedControlView) {
        self.listMovies = listMovies
        self.segmentedControl = segmentedControl
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func configure(with listSeries: [ListSeriesResults], segmentedControl: SegmentedControlView) {
        self.listSeries = listSeries
        self.segmentedControl = segmentedControl
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        if segmentedControl?.selectedSegmentIndex == 0 {
            cell.configureMoviePoster(with: listMovies, indexPath: indexPath)
        } else if segmentedControl?.selectedSegmentIndex == 1 {
            cell.configureSeriesPoster(with: listSeries, indexPath: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl?.selectedSegmentIndex == 0 {
            return listMovies.count
        } else if segmentedControl?.selectedSegmentIndex == 1 {
            return listSeries.count
        }
        return 0
    }
}
