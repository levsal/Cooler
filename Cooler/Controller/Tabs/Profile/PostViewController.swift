//
//  PostViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/12/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var postText = ""
    
    var delegate: ProfileViewController!
    
    @IBOutlet weak var postTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.delegate = self
        //Placeholder
        postTextView.textColor = .lightGray
        postTextView.text = "Type your post here"
        
        //Border
        postTextView.layer.borderWidth = 1
        postTextView.layer.borderColor = UIColor.red.cgColor
        postTextView.layer.cornerRadius = postTextView.layer.frame.width/40
    }
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        postText = postTextView.text
        print(postText)
        delegate.appendToArray(post: postText)
        db.collection("\((Auth.auth().currentUser?.email)!)_Posts").addDocument(data: ["text": postText, "date": -Date().timeIntervalSince1970]){ (error) in
            
            if let e = error{
                print("There was an issue saving data to Firestore, \(e)")
            } else{
            }
        }
        delegate.postTableView.reloadData()
        self.dismiss(animated: true) {
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileVC = segue.destination as! ProfileViewController
        profileVC.userEmail.text = "Test"
    }
    
}

extension PostViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        postTextView.text = ""
        postTextView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if postTextView.text == nil {
            postTextView.textColor = .lightGray
            postTextView.text = "Type your post here"
        }
    }
}
