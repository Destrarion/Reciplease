//
//  FridgeService.swift
//  Reciplease
//
//  Created by Fabien Dietrich on 02/04/2021.
//

import Foundation

protocol FridgeServiceDelegate: class {
    func ingredientsDidChange()
}

class FridgeService {
    
    weak var delegate: FridgeServiceDelegate?
    
    var ingredients: [String] = [] {
        didSet {
            delegate?.ingredientsDidChange()
        }
    }
    
    func add(ingredient: String) {
        ingredients.append(ingredient)
    }
    
    
    func removeIngredients() {
        ingredients.removeAll()
    }
    
    func removeIngredient(at index: Int) {
        ingredients.remove(at: index)
    }
}
