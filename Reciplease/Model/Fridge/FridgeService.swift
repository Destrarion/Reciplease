//
//  FridgeService.swift
//  Reciplease
//
//  Created by Fabien Dietrich on 02/04/2021.
//

import Foundation

protocol FridgeServiceDelegate: AnyObject {
    func ingredientsDidChange()
}

enum FridgeServiceError: Error {
    case failedToAddIngredientIsEmpty
    case failedToAddIngredientIsAlreadyAdded
    case failedToAddIngredientContainsSpecialCharacter
    
    var errorDescription: String {
        switch self {
        case .failedToAddIngredientIsEmpty: return "Ingredient is empty"
        case .failedToAddIngredientIsAlreadyAdded: return "Ingredient is already added"
        case .failedToAddIngredientContainsSpecialCharacter: return "Ingredient contains special character"
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
        
        //let translatedIngredient = translateUnicodeEmoji(ingredient: ingredient) ?? ingredient
        let trimmedIngredient = ingredient.trimmingCharacters(in: .whitespaces).lowercased()
        
        print(trimmedIngredient)
        
        guard !trimmedIngredient.isEmpty else {
            return .failure(.failedToAddIngredientIsEmpty)
        }
        
        guard !ingredients.contains(trimmedIngredient) else {
            return .failure(.failedToAddIngredientIsAlreadyAdded)
        }
        
        guard isIngredientValid(ingredient: trimmedIngredient) else {
            return .failure(.failedToAddIngredientContainsSpecialCharacter)
        }
        
        
        ingredients.append(trimmedIngredient)
        return .success(())
    }
    
    
    func removeIngredients() {
        ingredients.removeAll()
    }
    
    func removeIngredient(at index: Int) {
        ingredients.remove(at: index)
    }
    
    private func isIngredientValid(ingredient: String) -> Bool {
        let pattern = "^[A-Za-z]*$"
        
        
        let result = ingredient.range(of: pattern, options: .regularExpression)
        
        return result != nil
    }
    
}
