import Foundation
import UIKit

class RecipleaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    /// function for configuring the item in the Tab Bar Controller
    private func configureItems() {
        guard let items = tabBar.items else { return }
        
        for item in items {
            
            /// Constant for the font of the items
            guard let font = UIFont(name: "Marker felt", size: 20) else { return }
            
            let textAttributes: [NSAttributedString.Key : Any] = [
                .font : font
            ]
            
            item.setTitleTextAttributes(textAttributes, for: .normal)
            
            /// Color of the items when the item is  not selected
            tabBar.unselectedItemTintColor = .lightGray
            
            let selectedTextAttributes: [NSAttributedString.Key : Any] = [
                .foregroundColor: UIColor.white
            ]
            
            item.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        }
    }
    
}
