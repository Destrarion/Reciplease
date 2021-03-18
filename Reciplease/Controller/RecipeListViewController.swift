

import UIKit

class RecipeListViewController: UITableViewController {
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
    
    
    
    
    
    
    
    
}
