import Foundation

protocol RecipeUrlProviderProtocol {
    func createRecipeRequestUrl(ingredients: [String]) -> URL?
}

/// Main class to create the URL for fetching API for recipe.
class RecipeUrlProvider: RecipeUrlProviderProtocol {
    
    
    /// Create a URL fitting with the HTML with the ingredient
    ///
    /// Using urlComponent to create the URL
    /// 1. At first the function add in a variable String each ingredient in the array Ingredient in the fridge.
    /// For each ingredient in the array, check if the array is empty, if not, add an "," to the ingredientQuery.
    ///
    /// 2.  Creating the URL components, we add :
    ///     * Scheme = The scheme subcomponent of the URL.
    ///     * Host = The host subcomponent.
    ///     * Path = The path subcomponent.
    ///
    ///     And the Query items :
    ///     * q = Ingredients we added in the variable string ingredientQuary
    ///     * app_id = App_id found in the account of Edaman, in the dashboard -> Application -> Recipe Search API section -> ID  (https://developer.edamam.com/admin/applications)
    ///     * app_key= App_key found in the account of Edaman, in the dashboard -> Application -> Recipe Search API section ->  click on the row for the same ID and add the key
    ///     * from = The minimum of recipe
    ///     * to = the maximum of recipe , Developper account is allow to get to max 100 result.
    ///
    /// 3. Then it return the urlComponents.url
    ///
    /// - Parameter ingredients: Ingredient in the Fridge
    /// - Returns: URL created with URLComponents ( urlComponents.url )
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
