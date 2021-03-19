

import UIKit

class RecipeListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ardoiseImage = UIImage(named: "Background_Ardoise")
        let ardoiseImageView = UIImageView(image: ardoiseImage)
        ardoiseImageView.contentMode = .scaleAspectFill
        tableView.backgroundView = ardoiseImageView
    }
    
    
    
    @IBAction func didTapGoToRecipeListButton(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        performSegue(withIdentifier: "GoToRecipeDetailsSegue", sender: name)
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    @IBAction func didTapSaveNameButton(_ sender: UIButton) {
        nameLabel.text = nameTextField.text
    }
    
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
        return recipesTest.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipesTest[indexPath.row]
        
        cell.configure(recipeTest: recipe)
        
        return cell
    }
    
    
    
    var recipesTest: [RecipeTest] = [
        .init(title: "Pizza"),
        .init(title: "Pasta"),
        .init(title: "Rizotto")
    ]
    

    
    
}


class RecipeTest {
    init(title: String) {
        self.title = title
    }
    
    let title: String
}
