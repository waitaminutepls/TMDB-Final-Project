import UIKit
import SDWebImage

class MainPosterView: UIView {
    
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle(" RANDOM choice ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.borderColor = UIColor.yellow.cgColor
        button.layer.backgroundColor = UIColor.yellow.cgColor
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()
    
    private func addGradientLayer() {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        let gradientLayer = CAGradientLayer()
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        gradientLayer.colors = [UIColor.clear.cgColor, isDarkMode ? UIColor.black.cgColor : UIColor.white.cgColor]
        gradientLayer.locations = [0.8, 1.0]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                self.addGradientLayer()
            }
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addGradientLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        addGradientLayer()
    }
    
    func configureMovieHeader(with model: ListMoviesResults) {
        guard let posterPath = model.posterPath else { return }
        let imageURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
        guard let imageURL = URL(string: imageURLString) else { return }
        imageView.sd_setImage(with: imageURL, completed: nil)
    }
    
    func configureSeriesHeader(with model: ListSeriesResults) {
        guard let posterPath = model.posterPath else { return }
        let imageURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
        guard let imageURL = URL(string: imageURLString) else { return }
        imageView.sd_setImage(with: imageURL, completed: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
