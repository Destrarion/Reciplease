//
//  RecipleaseTabBarController.swift
//  Reciplease
//
//  Created by Fabien Dietrich on 19/03/2021.
//

import Foundation


import UIKit

class RecipleaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundImage = UIImage()
        configureItems()
    }
    
    private func configureItems() {
        guard let itens = tabBar.items else { return }
        
        for iten in itens {
            
            let font = UIFont.systemFont(ofSize: 20)
            
            let textAttributes: [NSAttributedString.Key : Any] = [
                .font : font
            ]
            
            iten.setTitleTextAttributes(textAttributes, for: .normal)
            
            tabBar.unselectedItemTintColor = .lightGray
            
            
            let selectedTextAttributes: [NSAttributedString.Key : Any] = [
                .font : font,
                .foregroundColor: UIColor.white
            ]
            
            iten.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        }
    }
    
}
