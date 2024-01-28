import UIKit
import SafariServices

class SafariController {
    static func openSafariController(with itemId: Int?, isMovie: Bool, from viewController: UIViewController) {
        guard let itemId = itemId else { return }
        let baseURL: String
        
        if isMovie {
            baseURL = "https://www.themoviedb.org/movie/"
        } else {
            baseURL = "https://www.themoviedb.org/tv/"
        }

        let urlString = baseURL + "\(itemId)"
        guard let url = URL(string: urlString) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true)
    }
    
    static func openSearchSafariController(with results: SearchResults, from viewController: UIViewController) {
        guard let itemId = results.id else { return }
        let baseURL: String
        
        if let _ = results.title, let _ = results.releaseDate {
            baseURL = "https://www.themoviedb.org/movie/"
        } else {
            baseURL = "https://www.themoviedb.org/tv/"
        }
        
        let urlString = baseURL + "\(itemId)"
        guard let url = URL(string: urlString) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true)
        
        
    }
}
