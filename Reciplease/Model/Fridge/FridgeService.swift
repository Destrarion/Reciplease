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

enum FridgeServiceError: Error {
    case failedToAddIngredientIsEmpty
    case failedToAddIngredientIsAlreadyAdded
    
    var errorDescription: String {
        switch self {
        case .failedToAddIngredientIsEmpty: return "Ingredient is empty"
        case .failedToAddIngredientIsAlreadyAdded: return "Ingredient is already added"
        }
    }
}

class FridgeService {
    
    weak var delegate: FridgeServiceDelegate?
    
    var ingredients: [String] = [] {
        didSet {
            delegate?.ingredientsDidChange()
        }
    }
    
    func add(ingredient: String) -> Result<Void, FridgeServiceError>  {
        
        guard !ingredient.isEmpty else {
            return .failure(.failedToAddIngredientIsEmpty)
        }
        
        guard !ingredients.contains(ingredient.lowercased()) else {
            return .failure(.failedToAddIngredientIsAlreadyAdded)
        }
        
        ingredients.append(ingredient.lowercased())
        return .success(())
    }
    
    
    func removeIngredients() {
        ingredients.removeAll()
    }
    
    func removeIngredient(at index: Int) {
        ingredients.remove(at: index)
    }
}
