import Foundation

enum RecipeServiceError: Error {
    case failedToGetRecipes
    case couldNotCreateURL
    case failedToGetRecipeImage
    
    var errorDescription: String {
        switch self {
        case .couldNotCreateURL: return "Could not create url"
        case .failedToGetRecipeImage: return "Failed to get recipe image"
        case .failedToGetRecipes: return "Failed to get recipes"
        }
    }
}


class RecipeService {
    
    /// Singleton Pattern for RecipeService. When Calling RecipeService, thank to Singleton pattern, it will be the same instance that wil be called
    static let shared = RecipeService()
    
    #warning("need more details on documentation")
    /// Initialiser of RecipeService.
    /// Using initialiser to personalise the networkManager and the RecipeUrlProvider in case this is for the code or for the test
    /// - Parameters:
    ///   - networkManager: The networkManager we choose to use, for Reciplease we use Alamofire, and for the test we will use the parameter of network manager to give him an network manager mock (AlamofireNetworkManagerMock)
    ///   - recipeUrlProvider:RecipeUrlProvider necessary to request recipe with url  with the ingredient, here set with a parameter in order to mock it for XCTest
    init(
        networkManager: NetworkManagerProtocol = AlamofireNetworkManager(),
        recipeUrlProvider: RecipeUrlProviderProtocol = RecipeUrlProvider(),
        recipeCoreDataManager: RecipeCoreDataManagerProtocol = RecipeCoreDataManager()
    ) {
        self.networkManager = networkManager
        self.recipeUrlProvider = recipeUrlProvider
        self.recipeCoreDataManager = recipeCoreDataManager
    }
    
    private let networkManager: NetworkManagerProtocol
    private let recipeUrlProvider: RecipeUrlProviderProtocol
    private let recipeCoreDataManager: RecipeCoreDataManagerProtocol
    
    var ingredients: [String] = []

    
    var searchedRecipes: [Recipe] = []
    
    var favoritedRecipes: [Recipe] {
        recipeCoreDataManager.getRecipes()
    }
    
    func getRecipes(ingredients: [String], callback: @escaping (Result<Void, RecipeServiceError>) -> Void) {
        guard let requestURL = recipeUrlProvider.createRecipeRequestUrl(ingredients: ingredients) else {
            callback(.failure(.couldNotCreateURL))
            return
        }
        networkManager.fetch(url: requestURL) { (result: Result<RecipeResponse, NetworkManagerError>) in
            switch result {
            case .failure:
                callback(.failure(.failedToGetRecipes))
                print(requestURL)
                return
            case .success(let response):
                let recipes = response.hits.map { $0.recipe }
                self.searchedRecipes = recipes
                callback(.success(()))
                print(requestURL)
                return
            }
        }
    }
    
    func getImageRecipe(recipe: Recipe , callback: @escaping (Result<Data, RecipeServiceError>)-> Void){
        guard let urlImage = URL(string: recipe.image) else {
            callback(.failure(.couldNotCreateURL))
            return
        }
        networkManager.fetchData(url: urlImage) { result in
            switch result {
            case .failure:
                callback(.failure(.failedToGetRecipeImage))
            case .success(let data):
                callback(.success(data))
            }
        }
    }
    
    
    func toggleRecipeToFavorite(recipe: Recipe) {
        let isAlreadyFavorited = isRecipeAlreadyFavorited(recipe: recipe)
        
        if isAlreadyFavorited {
            recipeCoreDataManager.deleteRecipe(with: recipe.label)
        } else {
            recipeCoreDataManager.addRecipe(recipe: recipe)
        }
       
    }
    
    
    
    private func isRecipeAlreadyFavorited(recipe: Recipe) -> Bool {
        favoritedRecipes.contains { favoritedRecipe in
            favoritedRecipe.label == recipe.label
        }
    }

  
    
    
    
    
}
