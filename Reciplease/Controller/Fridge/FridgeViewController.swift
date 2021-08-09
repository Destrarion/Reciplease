import UIKit

class FridgeViewController: UIViewController {
    
    private let fridgeService = FridgeService()
    private let recipeService = RecipeService.shared
    private let alertManager = AlertViewManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIngredientTableView()
        setPlaceholderColor()
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
        HapticsManager.shared.notificationVibrate(for: .error)
    }
    
    @IBAction func didTapGoToRecipeListButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        searchButton.isHidden = true
        if fridgeService.ingredients == [] {
            alertManager.presentAlert(on: self, errorMessage: FridgeServiceError.noIngredientInFridge.errorDescription)
            searchingRecipeProcessingEnd()
            return
        } else {
            recipeService.getRecipes(ingredients: fridgeService.ingredients) { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        self?.alertManager.presentAlert(on: self, errorMessage: error.errorDescription)
                    case .success:
                        self?.performSegue(withIdentifier: "GoToRecipeListSegue", sender: nil)
                    }
                    self?.searchingRecipeProcessingEnd()
                }
            }
        }
        
    }
    
    @IBAction func addIngredientInFridge(_ sender: UIButton) {
        addIngredient()
        HapticsManager.shared.notificationVibrate(for: .success)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let recipeListViewController = segue.destination as? RecipeListViewController {
            recipeListViewController.shouldDisplayFavorite = false
        }
        
    }
    
    /// Function for setting the placeholder in the UITextfield for avoiding transparent placeholder when the Iphone dispaly appareance is set on Dark mode
    func setPlaceholderColor() {
        let placeholder = addIngredientTextField.placeholder ?? ""
        let placeholderAttributedString = NSMutableAttributedString(string: placeholder)
        let range = (placeholder as NSString).range(of: placeholder)
        let foregroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
        placeholderAttributedString.addAttribute(.foregroundColor, value: foregroundColor, range: range)
        
        addIngredientTextField.attributedPlaceholder = placeholderAttributedString
    }
    
    /// Function for stopping the activity indicator from animating and the search button to reappear.
    func searchingRecipeProcessingEnd(){
        searchButton.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    /// Function for adding ingredient into the fridge.
    private func addIngredient() {
        guard let ingredient = addIngredientTextField.text else { return }
        
        switch fridgeService.add(ingredient: ingredient) {
        case .failure(let error):
            alertManager.presentAlert(on: self, errorMessage: error.errorDescription)
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
            HapticsManager.shared.notificationVibrate(for: .error)
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
        if textField.text?.isEmpty ?? true {
            textField.resignFirstResponder()
        } else {
            addIngredient()
        }
        return true
    }
}
