//
//  SignUpViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/3/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var signUpStackView: UIStackView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    self.welcomeMessage.textColor = .red
                    self.welcomeMessage.text = e.localizedDescription
                    print(e.localizedDescription)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let e = error{
                            self.welcomeMessage.textColor = .red
                            self.welcomeMessage.text = e.localizedDescription
                            print(e.localizedDescription)
                        } else {

                            
                            self.db.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(
                                
                                ["email": "\((Auth.auth().currentUser?.email)!)",
                                "date": -Date().timeIntervalSince1970,
                                "name" : name,
                                "picURL" : "https://firebasestorage.googleapis.com/v0/b/cooler-e529a.appspot.com/o/a@b.com_ProfilePic?alt=media&token=fcc65527-ff9a-4d14-ae71-3e780faf7f14",
                                "Artforms" : ["Albums", "Movies", "TV Shows", "Books"]])
                            
                            self.performSegue(withIdentifier: "signUpToTabs", sender: self)
                        }
                    }
                }
            }
        }
    }
}


