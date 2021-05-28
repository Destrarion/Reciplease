
import Foundation

protocol RecipeUrlProviderProtocol {
    func createRecipeRequestUrl(ingredients: [String]) -> URL?
}

class RecipeUrlProvider: RecipeUrlProviderProtocol {
    
    
    func createRecipeRequestUrl(ingredients: [String]) -> URL? {
        
        var ingredientQuery = ""
        for ingredient in ingredients{
            if !ingredientQuery.isEmpty{
                ingredientQuery.append(",")
            }
            ingredientQuery.append(ingredient)
        }
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.edamam.com"
        urlComponents.path = "/search"
        urlComponents.queryItems = [
            .init(name: "q", value: ingredientQuery),
            .init(name: "app_id", value: "24cc3abb"),
            .init(name: "app_key", value: "67d0ce73e19bd16320ed7534c84eb38f"),
            .init(name: "from", value: "0"),
            .init(name: "to", value: "50")
        ]
        
        return urlComponents.url
    }
}
