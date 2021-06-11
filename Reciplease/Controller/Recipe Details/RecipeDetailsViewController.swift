#warning("Need Documentation")

import UIKit
import SafariServices

class RecipeDetailsViewController: UIViewController, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIngredientTableView()
        titleRecipeLabel.text = recipe?.label
        getImage(recipe: recipe!)
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
    
    @IBAction func didTapOnOpenInstructionButton() {
        guard let recipeUrlString = recipe?.url,
              let recipeUrl = URL(string: recipeUrlString)
        else { return }
        
        let safariViewController = SFSafariViewController(url: recipeUrl)
        present(safariViewController, animated: true, completion: nil)
        
    }
    
    var recipe: Recipe?
    private var recipeService = RecipeService.shared
    private var alertManager = AlertViewManager()
    
    func getImage(recipe: Recipe) {
        activityIndicator.startAnimating()
        recipeService.getImageRecipe(
            recipe: recipe
         ) { [weak self] (result) in
            DispatchQueue.main.async {
        
                switch result {
                case .failure(let error):
                    print(error)
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
        gradientLayer.frame = CGRect(x: gradientView.frame.minX, y: 50, width: gradientView.frame.width, height: gradientView.frame.height)
        gradientLayer.colors = [UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), UIColor.black.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
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


