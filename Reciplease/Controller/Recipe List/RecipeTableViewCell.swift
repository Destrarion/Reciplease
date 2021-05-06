//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Fabien Dietrich on 19/03/2021.
//

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
    private var alertManager = AlertManager()
    
    private var gradientLayer: CAGradientLayer?

    
    private var lastLoadedRecipe: Recipe?
    
    func configure(recipe: Recipe) {
        recipeImageView.image = UIImage()
        lastLoadedRecipe = recipe
        
        recipeTitleLabel.text = recipe.label
        totalTimeLabel.text = "\(recipe.totalTime)"
        getImage(recipe: recipe)
        
        let recipeIngredientsSubtitle =
            Set(
                recipe.ingredients
                    .compactMap { $0.foodCategory }
            )
            .joined(separator: ", ")
        
        ingredientRecipeLabel.text = recipeIngredientsSubtitle
        addGradient()
        
    }
    
    func addGradient() {
        shadowView.layer.sublayers?.removeAll()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: shadowView.frame.minX, y: 50, width: shadowView.frame.width, height: shadowView.frame.height)
        gradientLayer.colors = [UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), UIColor.black.cgColor]
        shadowView.layer.addSublayer(gradientLayer)
    }
    
    

    func getImage(recipe: Recipe) {
        activityIndicator.startAnimating()
        recipeService.getImageRecipe(
            recipe: recipe
         ) { [weak self] (result) in
            DispatchQueue.main.async {
        
                switch result {
                case .failure(let error):
                    print(error)
                    self?.activityIndicator.stopAnimating()
                case .success(let response):
                    guard recipe.label == self?.lastLoadedRecipe?.label else { return }
                    let loadedImage = UIImage(data: response)
                    self?.recipeImageView.image = loadedImage
                    self?.activityIndicator.stopAnimating()
        
                }
            }
        }
    }
}
