import UIKit
import SDWebImage

class PosterHeaderView: UIView {
    
    // MARK: - Properties
    
    var currentItemId: Int?
    
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle(" RANDOM ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.borderColor = UIColor.yellow.cgColor
        button.layer.backgroundColor = UIColor.yellow.cgColor
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Movies", "TV"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.isOpaque = true
        return segmentedControl
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addGradientLayer()
    }
    
    // MARK: - Required Initialization
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        addGradientLayer()
    }
    
    // MARK: - Methods
    
    private func addGradientLayer() {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        let gradientLayer = CAGradientLayer()
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        gradientLayer.colors = [UIColor.clear.cgColor, isDarkMode ? UIColor.black.cgColor : UIColor.white.cgColor]
        gradientLayer.locations = [0.8, 1.0]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func configureHeader(with imagePath: String?) {
        guard let posterPath = imagePath,
              let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else {
            return
        }
        imageView.sd_setImage(with: imageURL, completed: nil)
    }
    
    public func configureMovieHeader(with model: ListMoviesResults) {
        configureHeader(with: model.posterPath)
        currentItemId = model.id
    }
    
    public func configureSeriesHeader(with model: ListSeriesResults) {
        configureHeader(with: model.posterPath)
        currentItemId = model.id
    }
    
    // MARK: - Trait Collection Changes
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                self.addGradientLayer()
            }
        })
    }
}
