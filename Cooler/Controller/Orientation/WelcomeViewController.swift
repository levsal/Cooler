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
        self.hideKeyboardWhenTappedAround()

        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.06139858812, green: 0.06141700596, blue: 0.06139617413, alpha: 1)
        
       

        //Title Font
//        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 18)!, NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 1)]
        
        self.navigationController?.navigationBar.tintColor = .white
        
        
    }
    //MARK: - Segues
    @IBAction func signUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "welcomeToSignUp", sender: self)
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        performSegue(withIdentifier: "welcomeToLogIn", sender: self)
    }
    
   
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
