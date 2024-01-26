import UIKit

class MainTabBarViewController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = makeNavigationController(rootViewController: HomeViewController(), tabBarItemImage: "house", title: "Home")
        let secondVC = makeNavigationController(rootViewController: SearchViewController(), tabBarItemImage: "magnifyingglass", title: "Search")
        let thirdVC = makeNavigationController(rootViewController: WatchLaterViewController(), tabBarItemImage: "clock", title: "Watch Later")
        
        setViewControllers([firstVC, secondVC, thirdVC], animated: true)
    }
    
    // MARK: - Methods
    
    private func makeNavigationController(rootViewController: UIViewController, tabBarItemImage: String, title: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = UIImage(systemName: tabBarItemImage)
        navigationController.tabBarItem.title = title
        return navigationController
    }
}
