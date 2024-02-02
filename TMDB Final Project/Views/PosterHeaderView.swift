import UIKit
import SDWebImage

class PosterHeaderView: UIView {
    
    // MARK: - Properties
    
    var currentItemId: Int?
    var currentItemTitle: String?
    var currentItemPosterPath: String?
    var currentItemOverview: String?
    
    let randomButton: UIButton = {
        let textColor = UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .black : .white
        }
        let backgroundColor = UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .white : .black
        }
        let button = UIButton(type: .system)
        button.tintColor = textColor
        button.backgroundColor = backgroundColor
        button.setTitle("Tap me", for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray2
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Movies", "TV"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.isOpaque = true
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(addButton) 
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
        bringSubviewToFront(addButton)
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
        currentItemTitle = model.title
        currentItemPosterPath = model.posterPath
        currentItemOverview = model.overview
        
        let isAddedToWatchList = RealmManager.shared.isAddedToWatchList(with: model.id!, isMovie: true)
        let buttonImageName = isAddedToWatchList ? "checkmark.circle" : "plus.circle"
        addButton.setImage(UIImage(systemName: buttonImageName), for: .normal)
    }
    
    public func configureSeriesHeader(with model: ListSeriesResults) {
        configureHeader(with: model.posterPath)
        currentItemId = model.id
        currentItemId = model.id
        currentItemTitle = model.name
        currentItemPosterPath = model.posterPath
        currentItemOverview = model.overview
        
        let isAddedToWatchList = RealmManager.shared.isAddedToWatchList(with: model.id!, isMovie: false)
        let buttonImageName = isAddedToWatchList ? "checkmark.circle" : "plus.circle"
        addButton.setImage(UIImage(systemName: buttonImageName), for: .normal)
    }
    
    private func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    private func setupLetterColor(for title: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: title)
        for (index, _) in title.enumerated() {
            let color = randomColor()
            let range = NSMakeRange(index, 1)
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        return attributedString
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
