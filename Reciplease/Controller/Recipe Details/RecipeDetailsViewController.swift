#warning("Need Documentation")
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addGradient()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchFavoriteButton(recipe: recipe!)
    }
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
    
    
    @IBAction func didTapOnOpenInstructionButton() {
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
    
    private var gradientLayer: CAGradientLayer?
    
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


