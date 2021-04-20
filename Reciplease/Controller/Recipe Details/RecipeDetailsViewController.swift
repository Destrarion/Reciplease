import UIKit

class RecipeDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(recipe?.label)
    }
    
    
    var recipe: Recipe?
}
