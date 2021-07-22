import Foundation
#warning("need documentation")
import UIKit

class RecipleaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tabBar.backgroundImage = UIImage()
        configureItems()
    }
    
    private func configureItems() {
        guard let items = tabBar.items else { return }
        
        for item in items {
            
            let font = UIFont.systemFont(ofSize: 20)
            
            let textAttributes: [NSAttributedString.Key : Any] = [
                .font : font
            ]
            
            item.setTitleTextAttributes(textAttributes, for: .normal)
            
            tabBar.unselectedItemTintColor = .lightGray
            
            
            let selectedTextAttributes: [NSAttributedString.Key : Any] = [
                .font : font,
                .foregroundColor: UIColor.white
            ]
            
            item.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        }
    }
    
}
