import UIKit

/// Class creating Popup if an error happen. Create Popup with the error description that happened.
class AlertViewManager {
    func presentAlert(on viewController: UIViewController?, error: RecipeServiceError) {
        guard let viewController = viewController else { return }
        
        let alertController = UIAlertController(
            title: "Error",
            message: error.errorDescription,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil)
        )
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func presentAlert(on viewController: UIViewController?, error: FridgeServiceError) {
        guard let viewController = viewController else { return }
        
        let alertController = UIAlertController(
            title: "Error",
            message: error.errorDescription,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil)
        )
        
        viewController.present(alertController, animated: true, completion: nil)
    }

}
