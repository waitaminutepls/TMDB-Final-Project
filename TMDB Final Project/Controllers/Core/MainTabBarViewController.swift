import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = UINavigationController(rootViewController: HomeViewController())
        let secondVC = UINavigationController(rootViewController: NewSearchViewController())
        let thirdVC = UINavigationController(rootViewController: WatchLaterViewController())
        
        firstVC.tabBarItem.image = UIImage(systemName: "house")
        firstVC.title = "Home"
        secondVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        secondVC.title = "Search"
        thirdVC.tabBarItem.image = UIImage(systemName: "clock")
        thirdVC.title = "Watch Later"
        
        tabBar.tintColor = .label
        setViewControllers([firstVC, secondVC, thirdVC], animated: true)
    }
}
