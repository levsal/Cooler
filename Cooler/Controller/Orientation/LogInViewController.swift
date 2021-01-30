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
    
    let db = Firestore.firestore()
    
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
                    self!.db.collection("Users").document(email).getDocument { (querySnapshot, error) in
                        if let e = error {
                            print("Error getting doc, \(e)")
                        }
                        else {
                            let data = querySnapshot?.data()
                            K.currentUserName = data!["name"] as! String
                            self!.db.collection("Users").document(email).getDocument { (querySnapshot, error) in
                                if let e = error {
                                    print("Error getting doc, \(e)")
                                }
                                else {
                                    let data = querySnapshot?.data()
                                    if let picURL = data!["picURL"] as? String {
                                        K.currentUserPicURL = picURL
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                    self!.performSegue(withIdentifier: "logInToTabs", sender: self)
                }
            }
        }
    }
}
