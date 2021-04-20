//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Fabien Dietrich on 19/03/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientRecipeLabel: UILabel!
    
    private var recipeService = RecipeService.shared
    

    
    func configure(recipe: Recipe) {
        recipeTitleLabel.text = recipe.label
        totalTimeLabel.text = "\(recipe.totalTime)"
        ingredientRecipeLabel.text = "\(recipe.ingredients)"
        print(shadowView.frame)
        shadowUIViewCell()
        print(recipe.ingredients.description)
    }
    
    func shadowUIViewCell() {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: shadowView.frame.minX, y: 50, width: shadowView.frame.width, height: shadowView.frame.height)
        layer.colors = [UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), UIColor.black.cgColor]
        shadowView.layer.addSublayer(layer)
        
    }
}
