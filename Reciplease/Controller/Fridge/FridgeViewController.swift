import UIKit

class FridgeViewController: UIViewController {
    
    private let fridgeService = FridgeService()
    private let recipeService = RecipeService.shared
    private let alertManager = AlertManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIngredientTableView()
        fridgeService.delegate = self
    }
    
    private func setupIngredientTableView() {
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
    }
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var addIngredientTextField: UITextField!
    
    
    @IBAction func didTapOnClearButton() {
        fridgeService.removeIngredients()
    }
    
    
    @IBAction func didTapGoToRecipeListButton(_ sender: UIButton) {

        if fridgeService.ingredients != [] {
            recipeService.getRecipes(ingredients: fridgeService.ingredients) { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        self?.alertManager.presentAlert(on: self, error: error)
                    case .success:
                        self?.performSegue(withIdentifier: "GoToRecipeListSegue", sender: nil)
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func addIngredientInFridge(_ sender: UIButton) {
        guard let ingredient = addIngredientTextField.text else { return }
        fridgeService.add(ingredient: ingredient)
        addIngredientTextField.text = ""
    }
}



extension FridgeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ingredientTitleLabel.text = fridgeService.ingredients[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fridgeService.ingredients.count
    }
}

extension FridgeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteContextItem = UIContextualAction(style: .destructive, title: "DELETE IT") { [weak self] (action, view, boolValueClosure) in
            self?.fridgeService.removeIngredient(at: indexPath.row)
        }
        
        deleteContextItem.backgroundColor = .gray
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem])
        return swipeActions
    }
}

extension FridgeViewController: FridgeServiceDelegate {
    func ingredientsDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.ingredientsTableView.reloadData()
        }
    }
}
