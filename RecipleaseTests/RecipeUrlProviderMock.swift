import Foundation

@testable import Reciplease

class RecipeUrlProviderMock: RecipeUrlProviderProtocol {
    func createRecipeRequestUrl(ingredients: [String]) -> URL? {
        return nil
    }
    
}
