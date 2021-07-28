import Foundation

/// Error corresponding of recipe after received by the API
/// - Failed to get Recipe: if the device couldn't get any recipe, due to device not connected to internet or other forms.
/// - Could not create URL: if the RecipeUrlProvider or the url of the image failed to be created.
/// - Failed to get recipe Image: if the image could not be received from the API.
enum RecipeServiceError: LocalizedError {
    /// If the device couldn't get any recipe, due to device not connected to internet or other forms.
    case failedToGetRecipes
    /// If the RecipeUrlProvider or the url of the image failed to be created.
    case couldNotCreateURL
    /// If the image could not be received from the API.
    case failedToGetRecipeImage
    /// If the device is not connected to internet
    case internetNotReachable
    
    /// Description of the error in String of the error occured.
    var errorDescription: String {
        switch self {
        case .couldNotCreateURL: return "Could not create url"
        case .failedToGetRecipeImage: return "Failed to get recipe image"
        case .failedToGetRecipes: return "Failed to get recipes"
        case .internetNotReachable: return " You are currently not connected to internet"
        }
    }
}


class RecipeService {
    
    /// Singleton Pattern for RecipeService. When Calling RecipeService, thank to Singleton pattern, it will be the same instance that wil be called
    static let shared = RecipeService()
    
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
    
    /// Variable array of searched recipe via alamofire with the ingredient on the fridge. Used for searching new recipe
    var searchedRecipes: [Recipe] = []
    
    /// Variable array of recipe listed as Favorite, all recipe listed as favorite from the user is on this variable array
    var favoritedRecipes: [Recipe] {
        recipeCoreDataManager.getRecipes()
    }
    
    /// Function to get recipe from  with the ingredients from the fridge given by the API Edamam.
    /// Return hits of recipe and then the function getRecipes translate it directly on array with only the recipe, then assign the recipe into the variable array searchedRecipes.
    /// - Parameters:
    ///   - ingredients: Ingredients stocked in the variable array ingredients in RecipeService
    ///   - callback: Void in the case of success, receive the hit of the recipe, else if error return RecipeServiceError
    func getRecipes(ingredients: [String], callback: @escaping (Result<Void, RecipeServiceError>) -> Void) {
        if networkManager.isConnectedToInternet() {
            guard let requestURL = recipeUrlProvider.createRecipeRequestUrl(ingredients: ingredients) else {
                callback(.failure(.couldNotCreateURL))
                return
            }
            networkManager.fetch(url: requestURL) { (result: Result<RecipeResponse, NetworkManagerError>) in
                switch result {
                case .failure:
                    callback(.failure(.failedToGetRecipes))
                    return
                case .success(let response):
                    let recipes = response.hits.map { $0.recipe }
                    
                    guard !recipes.isEmpty else {
                        callback(.failure(.failedToGetRecipes))
                        return
                    }
                    
                    
                    self.searchedRecipes = recipes
                    callback(.success(()))
                    return
                }
            }
        } else {
            callback(.failure(.internetNotReachable))
        }
    }
    
    /// Function executed after getting the recipe and the recipe is loading in the TableView of RecipeListController.
    /// After the Tableview is loaded and Cells (RecipeTableViewCell) is loaded, it then call getImageRecipe to download the image of the recipe of the cell.
    /// - Parameters:
    ///   - recipe: Recipe of the cell in order to get the URL of the API to get the image.
    ///   - callback: Return the image in Data if successfull, else return error of type RecipeServiceError.
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
    
    
    /// Function add/delete favorite recipe. At first it check if the recipe is already on favoriteRecipes var array, depend of the bool returned, will add or delete to/from the favoriteRecipes array.
    /// - Parameter recipe: recipe in quetion to be added or deleted from favoriteRecipes array.
    func toggleRecipeToFavorite(recipe: Recipe) {
        let isAlreadyFavorited = isRecipeAlreadyFavorited(recipe: recipe)
        
        if isAlreadyFavorited {
            recipeCoreDataManager.deleteRecipe(with: recipe.label)
        } else {
            recipeCoreDataManager.addRecipe(recipe: recipe)
        }
        
    }
    
    
    
    /// Function that return a Boolean if a recipe is already on favoriteRecipes array.
    /// - Parameter recipe: Recipe to check if favorite
    /// - Returns: Boolean : true if on favoriteRecipe , false if not present
    func isRecipeAlreadyFavorited(recipe: Recipe) -> Bool {
        favoritedRecipes.contains { favoritedRecipe in
            favoritedRecipe.label == recipe.label
        }
    }
    
    
    
    
    
    
}
