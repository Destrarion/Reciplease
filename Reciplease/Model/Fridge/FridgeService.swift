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
    /// The ingredients string is lowercased and delete extra whitespaces at the start and the end of the string
    /// - Parameter ingredient: This parameters contains the text of the outlet addIngredientTextField, it contain the ingredient the user written.
    ///
    /// Errors Possible:
    /// ---
    /// - **FailedToAddIngredientIsEmpty** : If the parametter *ingredient* is empty, to avoid getting an empty variable string into the ingredient of Fridgeservice, it return this error to avoid it.
    /// - **FailedToAddIngredientIsAlreadyAdded** : If the ingredient is already added into the ingredient of FridgeService, since the request of recipe does not require number of ingredients when creating the requestURL for recipe, it return this error to avoid double the same ingredient in the Ingredient array.
    /// - **FailedToAddIngredientContainsSpecialCharacter** : This error is destined to only accept regular expression. It call the Function of FridgeService isIngredientValid to verify if the string is a regular expression of the pattern. Avoiding Emoji or Different Alphabet (Russian keyboard for example)
    /// - Returns:
    ///     - **Success** : Add the trimmed ingredient to the array ingredients of FridgeService
    ///     - **Failure** : Return FridgeServiceError depend on the Error Encountered
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
    
    
    /// Function to remove all variables in the variable array ingredients of FridgeService
    func removeIngredients() {
        ingredients.removeAll()
    }
    
    /// Remove a ingredient in the fridge
    /// - Parameter index: Index of the array Ingredient
    func removeIngredient(at index: Int) {
        ingredients.remove(at: index)
    }
    
    #warning("Test with russian Keyboard or Asian Keyboard if this does not occure an error")
    private func isIngredientValid(ingredient: String) -> Bool {
        let pattern = "^[/S A-Za-z]*$"
        
        
        let result = ingredient.range(of: pattern, options: .regularExpression)
        
        return result != nil
    }
    
}
