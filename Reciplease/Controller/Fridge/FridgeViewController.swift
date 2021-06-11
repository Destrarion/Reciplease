import UIKit

#warning("Need Documentation")

class FridgeViewController: UIViewController {
    
    private let fridgeService = FridgeService()
    private let recipeService = RecipeService.shared
    private let alertManager = AlertViewManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIngredientTableView()
        fridgeService.delegate = self
        addIngredientTextField.delegate = self
        
        searchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        searchButton.titleLabel?.minimumScaleFactor = 0.5
        searchButton.layer.cornerRadius = 25
        clearButton.layer.cornerRadius = 15
        addButton.layer.cornerRadius = 15
        addButton.clipsToBounds = true
        
        
    }
    
    
    private func setupIngredientTableView() {
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
    }
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var addIngredientTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        addIngredientTextField.resignFirstResponder()
    }
    
    @IBAction func didTapOnClearButton() {
        fridgeService.removeIngredients()
    }
    
    
    @IBAction func didTapGoToRecipeListButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        if fridgeService.ingredients != [] {
            recipeService.getRecipes(ingredients: fridgeService.ingredients) { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        self?.alertManager.presentAlert(on: self, error: error)
                        self?.activityIndicator.stopAnimating()
                    case .success:
                        self?.performSegue(withIdentifier: "GoToRecipeListSegue", sender: nil)
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func addIngredientInFridge(_ sender: UIButton) {
        addIngredient()
    }
    
    private func addIngredient() {
        guard let ingredient = addIngredientTextField.text else { return }
        
        switch fridgeService.add(ingredient: ingredient) {
        case .failure(let error):
            alertManager.presentAlert(on: self, error: error)
        case .success:
            addIngredientTextField.text = ""
        }
    }
    
}



extension FridgeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? FridgeIngredientTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ingredientTitleLabel.text = "- \(fridgeService.ingredients[indexPath.row].capitalized)"
        
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
        
        deleteContextItem.backgroundColor = .red
        
        
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

extension FridgeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredient()
        return true
    }
}
