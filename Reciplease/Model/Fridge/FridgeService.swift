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

/// Enumeration concerning when adding ingredient if error happen.
/// Each case will return a string
/// Used for AlertManager that will open a Pop up with the errorDescription string corresponding to the error
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
    
    /// Ingredients is a array corresponding to what the user added in the Fridge.
    /// Ingredients are added or deleted in the Fridge
    /// Ingredients are showed in the TableView in the Fridge.
    /// Each time ingredients is modified, the delegate update in the FridgeViewController the TableView
    var ingredients: [String] = [] {
        didSet {
            delegate?.ingredientsDidChange()
        }
    }
    
    /// Function add is used when the user is adding ingredients in the variable ingredients
    /// The ingredients string is lowercased and
    func add(ingredient: String) -> Result<Void, FridgeServiceError>  {
        
        
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
        print(ingredients)
        return .success(())
    }
    
    
    func removeIngredients() {
        ingredients.removeAll()
    }
    
    func removeIngredient(at index: Int) {
        ingredients.remove(at: index)
    }
    
    private func isIngredientValid(ingredient: String) -> Bool {
        let pattern = "^[/S A-Za-z]*$"
        
        
        let result = ingredient.range(of: pattern, options: .regularExpression)
        
        return result != nil
    }
    
}
