import Foundation

class RecipeService {
    
    static let shared = RecipeService()
    
    init(
        networkManager: NetworkManagerProtocol = AlamofireNetworkManager(),
        recipeUrlProvider: RecipeUrlProviderProtocol = RecipeUrlProvider()
    ) {
        self.networkManager = networkManager
        self.recipeUrlProvider = recipeUrlProvider
    }
    
    private let networkManager: NetworkManagerProtocol
    private let recipeUrlProvider: RecipeUrlProviderProtocol
    
    var ingredients: [String] = []
    var recipes: [Recipe] = []
    
    func getRecipes(ingredients: [String], callback: @escaping (Result<Void, NetworkManagerError>) -> Void) {
        guard let requestURL = recipeUrlProvider.createRecipeRequestUrl(ingredients: ingredients) else {
            callback(.failure(.couldNotCreateURL))
            return
        }
        networkManager.fetch(url: requestURL) { (result: Result<RecipeResponse, NetworkManagerError>) in
            switch result {
            case .failure(let error):
                callback(.failure(error))
                print(requestURL)
                return
            case .success(let response):
                let recipes = response.hits.map { $0.recipe }
                self.recipes = recipes
                callback(.success(()))
                print(requestURL)
                return
            }
        }
    }
    
    func getImageRecipe(recipe: Recipe , callback: @escaping (Result<Data,NetworkManagerError>)-> Void){
        guard let urlImage = URL(string: recipe.image)
        else {
            callback(.failure(.couldNotCreateURL))
            return
        }
        networkManager.fetchData(url: urlImage, callback: callback)
    }
    
  
    
    
    
    
}
