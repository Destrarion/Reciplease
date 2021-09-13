import UIKit

class RecipeListViewController: UITableViewController {
    
    //MARK: - INTERNAL
    private var noRecipeLabel: UILabel?
    
    //MARK: INTERNAL - Properties
    var shouldDisplayFavorite = true
    
    //MARK: INTERNAL - Methods
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
    
    //MARK: - Private
    
    //MARK: Private - Properties
    
    /// recipesToDisplay is a private variable that contain the recipe to show on the TableView.
    /// The variable change with a operator Terner depending if the user choose recipe from favorite or searched for new recipes.
    private var recipesToDisplay: [Recipe] {
        shouldDisplayFavorite ?
            recipeService.favoritedRecipes :
            recipeService.searchedRecipes
    }
    /// Singleton Pattern for RecipeService. When Calling RecipeService, thank to Singleton pattern, it will be the same instance that wil be called
    private var recipeService = RecipeService.shared
    
    //MARK: Private - Methods
    /// Creating a label when selected Favorite and there's no recipe in favory.
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
    
    /// Function setting the background image with the other background of the application.
    /// Set in function due RecipeListViewController is directly created as UITableViewController, it need to be set manually in a function due in Storyboard the background can be only changed with a color and not an UIImage when using directly an UITableViewController.
    /// - Parameter image: String name of the image to set in the background.
    private func backgroundImageSetting(background image: String){
        let ardoiseImage = UIImage(named: image)
        let ardoiseImageView = UIImageView(image: ardoiseImage)
        ardoiseImageView.contentMode = .scaleAspectFill
        tableView.backgroundView = ardoiseImageView
    }
    
}
