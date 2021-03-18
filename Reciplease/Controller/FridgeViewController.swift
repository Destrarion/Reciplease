//
//  ViewController.swift
//  Reciplease
//
//  Created by Fabien Dietrich on 05/03/2021.
//

import UIKit

class FridgeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapGoToRecipeListButton(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToRecipeListSegue", sender: nil)
    }
    
}

