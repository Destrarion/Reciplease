import UIKit
import SafariServices

class RecipeDetailsViewController: UIViewController, UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet private weak var ingredientsTableView: UITableView!
    @IBOutlet private weak var titleRecipeLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageRecipe: UIImageView!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var timerLabel: UILabel!
    
    //MARK: - IBAction
    /// Action after pressing Get Direction, calling this fuction to open the url of the recipe on Safari Controller for more details on teh website.
    @IBAction func didTapOnGetDirectionButton() {
        guard let recipeUrlString = recipe?.url,
              let recipeUrl = URL(string: recipeUrlString)
        else { return }
        
        let safariViewController = SFSafariViewController(url: recipeUrl)
        safariViewController.preferredBarTintColor = UIColor.black
        safariViewController.preferredControlTintColor = UIColor.white
        present(safariViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapFavoriteButton() {
        guard let recipe = recipe else { return }
        recipeService.toggleRecipeToFavorite(recipe: recipe)
        switchFavoriteButton(recipe: recipe)
        
    }
    
    //MARK: - INTERNAL
    
    //MARK: Internal - Properties
    var recipe: Recipe?
    
    //MARK: Internal - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIngredientTableView()
        
        guard let recipe = recipe else { return }
        titleRecipeLabel.text = recipe.label
        getImage(recipe: recipe)
        timerLabel.text = recipe.formatCookingTimeToString()
        switchFavoriteButton(recipe: recipe)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let recipe = recipe else { return }
        switchFavoriteButton(recipe: recipe)
    }
    
    /// Function for filling the star in white if the recipe is on favorite.
    /// If not in favorite, set the inside of the star transparent.
    func switchFavoriteButton(recipe : Recipe) {
        if recipeService.isRecipeAlreadyFavorited(recipe: recipe){
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    //MARK: - PRIVATE
    
    //MARK: Private - Properties
    
    
    private var recipeService = RecipeService.shared
    private var alertManager = AlertViewManager()
    
    
    
    //MARK: Private - Methods
    
    /// Function to get the image of the recipe.
    private func getImage(recipe: Recipe) {
        activityIndicator.startAnimating()
        recipeService.getImageRecipe(
            recipe: recipe
         ) { [weak self] (result) in
            DispatchQueue.main.async {
        
                switch result {
                case .failure(let error):
                    print(error)
                    self?.imageRecipe.image = UIImage(named: "Image_Default_Recipe")
                    self?.activityIndicator.stopAnimating()
                case .success(let response):
                    guard recipe.label == self?.recipe?.label else { return }
                    let loadedImage = UIImage(data: response)
                    self?.imageRecipe.image = loadedImage
                    self?.activityIndicator.stopAnimating()
        
                }
            }
        }
    }
    
    /// Function to modifie the TableView of the list of ingredient.
    /// The dataSource for taking the information necessary to describe the ingredient of the recipe
    private func setupIngredientTableView() {
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
    }
}


//MARK: -
extension RecipeDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientDetailsCell", for: indexPath) as? DetailsIngredientTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ingredientDetailsTitleLabel.text = "- \(recipe?.ingredientLines[indexPath.row] ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredientLines.count ?? 0
    }
    
    
}


