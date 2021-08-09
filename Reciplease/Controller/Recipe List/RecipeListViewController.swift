#warning("Need Documentation")

import UIKit

class RecipeListViewController: UITableViewController {
    
    private var noRecipeLabel: UILabel?
    
    var shouldDisplayFavorite = true
    
    private var recipesToDisplay: [Recipe] {
        shouldDisplayFavorite ?
            recipeService.favoritedRecipes :
            recipeService.searchedRecipes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageSetting(background: "Background_Ardoise")
        messageIfNoFavorite()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        noRecipeLabel?.isHidden = !recipesToDisplay.isEmpty
    }
    
    private func messageIfNoFavorite() {
        let title = UILabel()
        title.text = "You have currently no favorite recipe"
        title.font = UIFont(name: "Marker felt", size: 20)
        title.numberOfLines = 2
        title.center = self.view.center
        title.textColor = UIColor.white
        title.sizeToFit()
        self.view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -100).isActive = true
        title.textAlignment = .center
        title.isHidden = true
        
        noRecipeLabel = title
    }
    
    func backgroundImageSetting(background image: String){
        let ardoiseImage = UIImage(named: image)
        let ardoiseImageView = UIImageView(image: ardoiseImage)
        ardoiseImageView.contentMode = .scaleAspectFill
        tableView.backgroundView = ardoiseImageView
    }
    
    var alertManager = AlertViewManager()
    private var recipeService = RecipeService.shared
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if
            let destination = segue.destination as? RecipeDetailsViewController,
            let recipe = sender as? Recipe
        {
            destination.recipe = recipe
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipesToDisplay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipesToDisplay[indexPath.row]
        
        cell.configure(recipe: recipe)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipesToDisplay[indexPath.row]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "GoToRecipeDetailsSegue", sender: recipe)
        }
    }
    
    
}
