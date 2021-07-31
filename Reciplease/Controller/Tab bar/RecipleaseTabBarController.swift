import Foundation
#warning("need documentation")
import UIKit
#warning("Not responsive for iphone 8, Item text too low compared to Iphone 12 (vient du bouton home")
class RecipleaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tabBar.backgroundImage = UIImage()
        configureItems()
    }
    
    private func configureItems() {
        guard let items = tabBar.items else { return }
        
        for item in items {
            
            guard let font = UIFont(name: "Marker felt", size: 20) else { return }
            
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
