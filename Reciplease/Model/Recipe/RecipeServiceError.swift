import Foundation
/// Error corresponding of recipe after received by the API
/// - Failed to get Recipe: if the device couldn't get any recipe, due to device not connected to internet or other forms.
/// - Could not create URL: if the RecipeUrlProvider or the url of the image failed to be created.
/// - Failed to get recipe Image: if the image could not be received from the API.
enum RecipeServiceError: LocalizedError {
    /// If the device couldn't get any recipe, due to device not connected to internet or other forms.
    case failedToGetRecipesRequestFailure
    /// If the device couldn't get any recipe, due to device not connected to internet or other forms.
    case failedToGetRecipesEmptyHits
    
    /// If the RecipeUrlProvider or the url of the image failed to be created.
    case couldNotCreateURL
    /// If the image could not be received from the API.
    case failedToGetRecipeImage
    /// If the device is not connected to internet
    case internetNotReachable
    /// If the array of ingredient is empty.
    case ingredientListIsEmpty
    
    /// Description of the error in String of the error occured.
    var errorDescription: String {
        switch self {
        case .couldNotCreateURL: return "Could not create url"
        case .failedToGetRecipeImage: return "Failed to get recipe image"
        case .failedToGetRecipesRequestFailure: return "Failed to get recipes - Request failed"
        case .failedToGetRecipesEmptyHits: return "Failed to recipes - No corresponding hits"
        case .internetNotReachable: return " You are currently not connected to internet"
        case .ingredientListIsEmpty: return "Ingredients list is empty"
        }
    }
}
