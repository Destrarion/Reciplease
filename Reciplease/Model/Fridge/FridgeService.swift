import Foundation

protocol FridgeServiceDelegate: AnyObject {
    func ingredientsDidChange()
}

/// Enumeration concerning when adding ingredient if error happen.
/// Each case will return a string
/// Used for AlertManager that will open a Pop up with the errorDescription string corresponding to the error
/// 1. Failed to add ingredient is empty : if the user give an white space ingredient, return this error
/// 2. Failed to add ingredient is already added : If the ingredient is already added into the fridge
///
/// 3. Failed to add ingredient contains special character : if the ingredient contain special character.
///  Example :
///
///     * Emoji : due to the emoji (📑) or their translation in unicode (Unicode: U+1F4D1, UTF-8: F0 9F 93 91)
///     * Non Regular expression : due to URL and API not accepting other alphabetic than English ( example russian keyboard )
enum FridgeServiceError: LocalizedError {
    /// If the user give an white space ingredient, return this error
    case failedToAddIngredientIsEmpty
    /// If the ingredient is already added into the fridge
    case failedToAddIngredientIsAlreadyAdded
    /// If the ingredient contain special character.
    /// * Emoji : due to the emoji (📑) or their translation in unicode (Unicode: U+1F4D1, UTF-8: F0 9F 93 91)
    /// * Non Regular expression : due to URL and API not accepting other alphabetic than English ( example russian keyboard )
    case failedToAddIngredientContainsSpecialCharacter
    /// if the ingredient in Fridge is empty,
    ///
    /// Error Description:
    /// ---
    /// " There is no ingredient added in the Fridge. Add Ingredient in Fridge to search new recipe"
    case noIngredientInFridge
    
    var errorDescription: String {
        switch self {
        case .failedToAddIngredientIsEmpty: return "Ingredient is empty"
        case .failedToAddIngredientIsAlreadyAdded: return "Ingredient is already added"
        case .failedToAddIngredientContainsSpecialCharacter: return "Ingredient contains special character"
        case .noIngredientInFridge: return "There is no ingredient added in the Fridge. Add Ingredient in Fridge to search new recipe"
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
    
    
    /// Function to remove all variables in the variable array ingredients of FridgeService
    func removeIngredients() {
        ingredients.removeAll()
    }
    
    /// Remove a ingredient in the fridge
    /// - Parameter index: Index of the array Ingredient
    func removeIngredient(at index: Int) {
        ingredients.remove(at: index)
    }
    
    /// Function checking if the ingredient added by the user is valid as regularExpression with the given pattern to fit when creating URL for fetching recipe.
    ///
    /// More information about the pattern at (  https://cheatography.com/davechild/cheat-sheets/regular-expressions/ )
    /// - Parameter ingredient: Ingredient the user give
    /// - Returns: Boolean , false it the ingredient does not fit the pattern of regular expression, true if it fit the patter of regularexpression.
    private func isIngredientValid(ingredient: String) -> Bool {
        let pattern = "^[/S A-Za-z]*$"
        
        let result = ingredient.range(of: pattern, options: .regularExpression)
        
        return result != nil
    }
    
}
