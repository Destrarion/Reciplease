import UIKit

class RecipeDetailsViewController: UIViewController, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIngredientTableView()
        print(recipe?.label)
    }
    
    private func setupIngredientTableView() {
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
    }
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var titleRecipeLabel: UILabel!
    
    
    var recipe: Recipe?
}


extension RecipeDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientDetailsCell", for: indexPath) as? DetailsIngredientTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ingredientDetailsTitleLabel.text = "- \(recipe?.ingredientLines[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredientLines.count ?? 0
    }
}


