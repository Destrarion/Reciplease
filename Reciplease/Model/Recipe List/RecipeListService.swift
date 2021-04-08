import Foundation

class RecipeService {
    
    init(
        networkManager: NetworkManagerProtocol = NetworkManager(),
        recipeUrlProvider: RecipeUrlProviderProtocol = RecipeUrlProvider()
    ) {
        self.networkManager = networkManager
        self.recipeUrlProvider = recipeUrlProvider
    }
    
    private let networkManager: NetworkManagerProtocol
    private let recipeUrlProvider: RecipeUrlProviderProtocol
    
    var name = ""
    var ingredients: [String] = []
    
    func getRecipes(ingredients: [String], callback: @escaping (Result<[Recipe], NetworkManagerError>) -> Void) {
        guard let requestURL = recipeUrlProvider.createRecipeRequestUrl(ingredients: ingredients) else {
            callback(.failure(.couldNotCreateURL))
            return
        }
        networkManager.fetch(url: requestURL) { (result: Result<RecipeResponse, NetworkManagerError>) in
            switch result {
            case .failure(let error):
                callback(.failure(error))
                return
            case .success(let response):
                let recipes = response.hits.map { $0.recipe }
                callback(.success(recipes))
                return
            }
        }
    }
    
    
    
}
