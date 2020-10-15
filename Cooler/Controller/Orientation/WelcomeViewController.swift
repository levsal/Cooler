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

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Auth.auth().currentUser?.email)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Segues
    @IBAction func signUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "welcomeToSignUp", sender: self)
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        performSegue(withIdentifier: "welcomeToLogIn", sender: self)
    }
    
}

