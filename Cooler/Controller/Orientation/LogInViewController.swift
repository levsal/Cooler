//
//  LogInViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/3/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()


    }
    
    
    @IBAction func logInPressed(_ sender: Any) {
    if let email = emailTextField.text ,let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error{
                    print(e)
                }
                else {
                    self!.performSegue(withIdentifier: "logInToTabs", sender: self)
                }
            }
        }
    }
}
