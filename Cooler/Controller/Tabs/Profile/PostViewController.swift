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
    
    var categories = ["Album", "Movie", "TV Show", "Book"]
    var categoryColors = [#colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1), #colorLiteral(red: 0.8735565543, green: 0.705497086, blue: 0.1316877007, alpha: 1), #colorLiteral(red: 0, green: 0.7927191854, blue: 0, alpha: 1), #colorLiteral(red: 0.838627696, green: 0.3329468966, blue: 0.3190356791, alpha: 1)]
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
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

extension PostViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "OpenSans-Bold", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        pickerLabel?.text = categories[row]
        pickerLabel?.textColor = categoryColors[row]
        return pickerLabel!
    }
    
}
