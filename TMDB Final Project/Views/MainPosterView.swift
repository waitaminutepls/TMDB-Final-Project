import UIKit
import SDWebImage

class MainPosterView: UIView {
    
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle(" RANDOM ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
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
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            addGradientLayer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addGradientLayer()
        addSubview(randomButton)
        applyConstraints()
    }
    
    private func applyConstraints() {
        let randomButtonConstraints = [
            randomButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            randomButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(randomButtonConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        addGradientLayer()
    }
    
    func configure(with model: ListMoviesResults) {
        guard let posterPath = model.posterPath else { return }
        let imageURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
        guard let imageURL = URL(string: imageURLString) else { return }
        imageView.sd_setImage(with: imageURL, completed: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

