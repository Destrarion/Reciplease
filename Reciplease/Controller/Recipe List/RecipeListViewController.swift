

import UIKit

class RecipeListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ardoiseImage = UIImage(named: "Background_Ardoise")
        let ardoiseImageView = UIImageView(image: ardoiseImage)
        ardoiseImageView.contentMode = .scaleAspectFill
        tableView.backgroundView = ardoiseImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func didTapGoToRecipeListButton(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        performSegue(withIdentifier: "GoToRecipeDetailsSegue", sender: name)
    }
    
    
    @IBAction func didTapSaveNameButton(_ sender: UIButton) {
        nameLabel.text = nameTextField.text
    }
    
    var alertManager = AlertManager()
    private var recipeService = RecipeService.shared
    
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if
            let destination = segue.destination as? RecipeDetailsViewController ,
            let name = sender as? String
        {
            destination.name = name
        }
        
    }
    
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeService.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipeService.recipes[indexPath.row]
        
        cell.configure(recipe: recipe)
        
        return cell
    }
    
    

    
    
}



