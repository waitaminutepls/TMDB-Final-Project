import UIKit
import SDWebImage

class UpperCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
           let imageView = UIImageView()
           imageView.clipsToBounds = true
           return imageView
       }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder : coder)
        setupUI()
        addGradientLayer()
    }
    
    func setupUI() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func addGradientLayer() {
            let gradientLayer = CAGradientLayer()
            let isDarkMode = traitCollection.userInterfaceStyle == .dark
            gradientLayer.colors = [UIColor.clear.cgColor, isDarkMode ? UIColor.black.cgColor : UIColor.white.cgColor]
            gradientLayer.locations = [0.8, 1.0]
            gradientLayer.frame = bounds
            
            imageView.layer.addSublayer(gradientLayer)
        }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           super.traitCollectionDidChange(previousTraitCollection)
           if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
               addGradientLayer()
           }
       }
    
    func configure(with posterPath: String?, baseURL: String = "https://image.tmdb.org/t/p/w500") {
            if let posterPath = posterPath, let posterURL = URL(string: baseURL + posterPath) {
                imageView.sd_setImage(with: posterURL, completed: nil)
            }
        }
    
    func configure(with coverImage: UIImage) {
        imageView.image = coverImage
        setNeedsLayout()
    }
}

