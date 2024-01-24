import UIKit


class SegmentedControlView: UISegmentedControl {
    
    static let identifier = "SegmentedControlView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.insertSegment(withTitle: "Movies", at: 0, animated: true)
        self.insertSegment(withTitle: "TV Shows", at: 1, animated: true)
        self.selectedSegmentIndex = 0
        self.backgroundColor = .systemBackground
        self.isOpaque = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
