//
//  WelcomeViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/2/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Segues
    @IBAction func signUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "welcomeToSignUp", sender: self)
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        performSegue(withIdentifier: "welcomeToLogIn", sender: self)
    }
    
   
    
}

