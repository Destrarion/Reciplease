import UIKit

/// Class creating Popup if an error happen. Create Popup with the error description that happened.
class AlertViewManager {
    #warning("can't i use extension of Error and group up all error i got in there, so i can just use Error for presentAlert ?")
    func presentAlert(on viewController: UIViewController?, error: LocalizedError) {
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
