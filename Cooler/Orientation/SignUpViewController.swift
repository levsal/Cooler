//
//  SignUpViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/3/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var signUpStackView: UIStackView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func signUpPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    self.welcomeMessage.textColor = .red
                    self.welcomeMessage.text = e.localizedDescription
                    print(e.localizedDescription)
                } else {
                    //Navigate to the chat
                    self.performSegue(withIdentifier: "signUpToTabs", sender: self)
                }
            }
        }
    }
}
