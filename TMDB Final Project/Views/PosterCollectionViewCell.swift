import UIKit
import SDWebImage

class PosterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "PosterCollectionViewCell"
    private var addClosure: (() -> Void)?
    
    // MARK: - UI Elements
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    // MARK: - Required Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupEditMenuInteraction()
        posterImageView.frame = contentView.bounds
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    // MARK: - Methods
    
    private func configurePoster(with imagePath: String?) {
        guard let posterPath = imagePath,
              let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else {
            return
        }
        posterImageView.sd_setImage(with: imageURL, completed: nil)
    }
    
    public func configureMoviePoster(with model: ListMoviesResults) {
        configurePoster(with: model.posterPath)
    }
    
    public func configureSeriesPoster(with model: ListSeriesResults) {
        configurePoster(with: model.posterPath)
    }
    
    public func configureSearchPoster(with model: SearchResults) {
        configurePoster(with: model.posterPath)
    }
    
    private func setupEditMenuInteraction() {
        let editInteraction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(editInteraction)
    }
    
    func setItemClosure(_ closure: @escaping (() -> Void)) {
        self.addClosure = closure
    }
}

// MARK: - Extensions PosterCollectionViewCell

extension PosterCollectionViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let addItem = UIAction(
            title: "Add to Watch Later",
            image: UIImage(systemName: "plus"),
            identifier: nil,
            discoverabilityTitle: nil,
            attributes: [],
            state: .off
        ) { [weak self] _ in
            self?.addClosure?()
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [addItem])
        }
    }
}
