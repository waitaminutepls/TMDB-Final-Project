import UIKit
import SDWebImage


class PosterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PosterCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    func configureMoviePoster(with model: [ListMoviesResults], indexPath: IndexPath) {
        guard !model.isEmpty else { return }
        let movie = model[indexPath.row]
        guard let posterPath = movie.posterPath else { return }
        let imageURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
        guard let imageURL = URL(string: imageURLString) else { return }
        posterImageView.sd_setImage(with: imageURL, completed: nil)
    }
    
    func configureSeriesPoster(with model: [ListSeriesResults], indexPath: IndexPath) {
        guard !model.isEmpty else { return }
        let tvShow = model[indexPath.row]
        guard let posterPath = tvShow.posterPath else { return }
        let imageURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
        guard let imageURL = URL(string: imageURLString) else { return }
        posterImageView.sd_setImage(with: imageURL, completed: nil)
    }
}
