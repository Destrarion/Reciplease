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

    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    
    func configure(recipeTest: RecipeTest) {
        recipeTitleLabel.text = recipeTest.title
    }
}
