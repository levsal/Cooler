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
    
    var selectedCategory : String?
    
    @IBOutlet weak var categoryHeader: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSMutableAttributedString.init(string: "Categories")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
        categoryHeader.attributedText = attributedString
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        postTextView.delegate = self
        //Placeholder
        postTextView.textColor = .lightGray
        postTextView.text = "Type your post here"
        
        //Border
        //        postTextView.layer.borderWidth = 1
        //        postTextView.layer.borderColor = UIColor.red.cgColor
        //        postTextView.layer.cornerRadius = postTextView.layer.frame.width/40
    }
    
    //MARK: - Post Pressed
    @IBAction func postButtonPressed(_ sender: Any) {
        
        if postTextView.text != "" {
            
            postText = postTextView.text
            
            let dateReversed = -Date().timeIntervalSince1970
            
            delegate.appendToArray(post: Post(user: nil, date: dateReversed, postText: postText, category: categories[categoryPicker.selectedRow(inComponent: 0)]))
            
            db.collection("\((Auth.auth().currentUser?.email)!)_Posts").addDocument(data: ["text": postText, "date": dateReversed, "category": categories[categoryPicker.selectedRow(inComponent: 0)]]){ (error) in
                
                if let e = error{
                    print("There was an issue saving data to Firestore, \(e)")
                } else{
                    
                }
            }
            delegate.postTableView.reloadData()
            self.dismiss(animated: true) {
                
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileVC = segue.destination as! ProfileViewController
        profileVC.userEmail!.text = "Test"
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
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
