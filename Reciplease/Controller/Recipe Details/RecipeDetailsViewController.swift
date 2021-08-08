import UIKit
import SafariServices

class RecipeDetailsViewController: UIViewController, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIngredientTableView()
        titleRecipeLabel.text = recipe?.label
        getImage(recipe: recipe!)
        timerLabel.text = recipe?.formatCookingTimeToString()
        switchFavoriteButton(recipe: recipe!)
    }
    
    
    /// viewDidLayoutSubviews is called after the view is loaded.
    /// The gradient is added after the view is loaded to fit the exact size of the view.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addGradient()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchFavoriteButton(recipe: recipe!)
    }
    
    /// Function to modifie the TableView of the list of ingredient.
    #warning("delegate is assigned to what before assigned to self ? to the storybard before the code?")
    /// The delegate of TableView
    /// The dataSource for taking the information necessary to describe the ingredient of the recipe
    private func setupIngredientTableView() {
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
    }
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var titleRecipeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
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
    
    
    var recipe: Recipe?
    private var recipeService = RecipeService.shared
    private var alertManager = AlertViewManager()
    
    #warning("what was that for if we create a let of CAGradient layer already in addGradient function ?")
    private var gradientLayer: CAGradientLayer?
    
    /// Function to get the image of the recipe.
    func getImage(recipe: Recipe) {
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
    
    /// Function for adding the gradient on the Gradient view between the image of the recipe and the title of the recipe.
    func addGradient() {
        gradientView.layer.sublayers?.removeAll()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.frame
        
        let bottomColor = UIColor.black.withAlphaComponent(0.8).cgColor
        
        gradientLayer.colors = [UIColor.clear.cgColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        gradientView.layer.addSublayer(gradientLayer)
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
}



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


