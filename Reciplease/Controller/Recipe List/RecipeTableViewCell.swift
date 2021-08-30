import UIKit

class RecipeTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var recipeTitleLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var ingredientRecipeLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK:- INTERNAL
    
    //MARK: INTERNAL - Methods

    /// Primary function for configuring cell of the TableView.
    /// This function assign :
    ///  * Image of the recipe
    ///  * Label = name of the recipe
    ///  * TotalTimeLabel = total time estimated for the recipe
    ///  * Sample of foodcategory = what category of food the recipe might contain.
    /// - Parameter recipe: Recipe assigned for the cell.
    func configure(recipe: Recipe) {
        /// reset the image by default
        recipeImageView.image = UIImage()
        lastLoadedRecipe = recipe
        
        recipeTitleLabel.text = recipe.label
        totalTimeLabel.text = recipe.formatCookingTimeToString()
        getImage(recipe: recipe)
        
    
        
        var filteredIngredients: [Ingredient] = []
        
        for ingredient in recipe.ingredients {
            if !filteredIngredients.contains(where: { $0.foodCategory == ingredient.foodCategory }) {
                filteredIngredients.append(ingredient)
            }
        }
        
        
        ingredientRecipeLabel.text = filteredIngredients.compactMap { $0.foodCategory }
            .joined(separator: ", ")
    }
    
    private func getImage(recipe: Recipe) {
        activityIndicator.startAnimating()
        recipeService.getImageRecipe(
            recipe: recipe
         ) { [weak self] (result) in
            DispatchQueue.main.async {
        
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .failure(let error):
                    print(error)
                    self?.recipeImageView.image = UIImage(named: "Image_Default_Recipe")
                case .success(let response):
                    guard recipe.label == self?.lastLoadedRecipe?.label else { return }
                    if let loadedImage = UIImage(data: response) {
                        self?.recipeImageView.image = loadedImage
                    } else {
                        self?.recipeImageView.image = UIImage(named: "Image_Default_Recipe")
                    }
                }
            }
        }
    }
    
    //MARK: - PRIVATE
    
    //MARK: Private - Propreties
    
    /// Singleton Pattern for RecipeService. When Calling RecipeService, thank to Singleton pattern, it will be the same instance that wil be called
    private var recipeService = RecipeService.shared

    
    private var lastLoadedRecipe: Recipe?
    
}
