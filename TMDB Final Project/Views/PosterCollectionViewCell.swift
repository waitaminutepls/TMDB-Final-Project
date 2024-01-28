import UIKit
import SDWebImage

class PosterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "PosterCollectionViewCell"
    
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
        fatalError()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
}
