#warning("Need Documentation")

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

import UIKit

class RecipeTableViewCell: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientRecipeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var recipeService = RecipeService.shared

    
    private var lastLoadedRecipe: Recipe?
    
    func configure(recipe: Recipe) {
        recipeImageView.image = UIImage()
        lastLoadedRecipe = recipe
        
        recipeTitleLabel.text = recipe.label
        totalTimeLabel.text = recipe.formatCookingTimeToString()
        getImage(recipe: recipe)
        
        let recipeIngredientsSubtitle =
            recipe.ingredients
                .compactMap { $0.foodCategory }
                .joined(separator: ", ")
        
        ingredientRecipeLabel.text = recipeIngredientsSubtitle
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
    
    
}
