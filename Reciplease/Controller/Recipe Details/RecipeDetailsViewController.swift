import UIKit

class RecipeDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
    }
    @IBOutlet weak var nameLabel: UILabel!
    var name : String?
}
