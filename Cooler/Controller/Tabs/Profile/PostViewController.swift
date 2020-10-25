//
//  PostViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/12/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PostViewController: UIViewController {

    let db = Firestore.firestore()
    
    var delegate: ProfileViewController!
    
    var categories = ["Album", "Movie", "TV Show", "Book"]
    var categoryColors = [#colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1), #colorLiteral(red: 0.8735565543, green: 0.705497086, blue: 0.1316877007, alpha: 1), #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
    
    var selectedCategory : String?
    
    @IBOutlet weak var categoryHeader: UILabel!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var ratingPicker: UIPickerView!
    
    //User Input
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var creatorTextView: UITextView!
    @IBOutlet weak var blurbTextView: UITextView!
    
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSMutableAttributedString.init(string: "Categories")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
        categoryHeader.attributedText = attributedString
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        ratingPicker.dataSource = self
        ratingPicker.delegate = self
        
        postTextView.delegate = self
        creatorTextView.delegate = self
        blurbTextView.delegate = self
        //Placeholder
        postTextView.textColor = .lightGray
        creatorTextView.textColor = .lightGray
        blurbTextView.textColor = .lightGray
        
        postTextView.layer.borderWidth = 1
        postTextView.layer.borderColor = UIColor.black.cgColor
        creatorTextView.layer.borderWidth = 1
        creatorTextView.layer.borderColor = UIColor.black.cgColor
        blurbTextView.layer.borderWidth = 1
        blurbTextView.layer.borderColor = UIColor.black.cgColor
        
       
        
        //        postTextView.layer.cornerRadius = postTextView.layer.frame.width/40
    }
    
    //MARK: - Post Pressed
    @IBAction func postButtonPressed(_ sender: Any) {
        
        if postTextView.text != "" && postTextView.text != nil && postTextView.text != "Work" && creatorTextView.text != "" && creatorTextView.text != nil && creatorTextView.text != "Creator" && blurbTextView.text != "" && blurbTextView.text != nil && blurbTextView.text != "Blurb" {
            
            let postText = postTextView.text
            let creatorText = creatorTextView.text
            let blurbText = blurbTextView.text
            let selectedCategory = categories[categoryPicker.selectedRow(inComponent: 0)]
            let givenRating = Double(ratingPicker.selectedRow(inComponent: 0))/10.0
            let dateReversed = -Date().timeIntervalSince1970
            
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .none

            let dateTime = formatter.string(from: date)
                        
            
            delegate.appendToArray(post: Post(date: dateReversed, dateString: dateTime, postText: postText!, category: selectedCategory, creator: creatorText!, blurb: blurbText!, rating: givenRating))
            
            db.collection("\((delegate.email))_Posts").document(postText!).setData(["text": postText! as String, "date": dateReversed, "category": categories[categoryPicker.selectedRow(inComponent: 0)], "creator": creatorText!,"blurb" : blurbText!, "rating": givenRating, "dateString" : dateTime]){ (error) in
                
                if let e = error{
                    print("There was an issue saving data to Firestore, \(e)")
                } else{
                    
                }
            }
            delegate.postTableView.reloadData()
            postTextView.text = ""
            creatorTextView.text = ""
            blurbTextView.text = ""
            self.dismiss(animated: true) {
                
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileVC = segue.destination as! ProfileViewController
        profileVC.username!.text = "Test"
    }
    
}

extension PostViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == postTextView, postTextView.text == "Work" {
            postTextView.text = ""
            postTextView.textColor = .black
        }
        else if textView == creatorTextView, creatorTextView.text == "Creator"  {
            creatorTextView.text = ""
            creatorTextView.textColor = .black
        }
        else if textView == blurbTextView, blurbTextView.text == "Blurb"  {
                blurbTextView.text = ""
                blurbTextView.textColor = .black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == postTextView {
            if postTextView.text == "" {
                postTextView.textColor = .lightGray
                postTextView.text = "Work"
            }
        }
        else if textView == creatorTextView {
            if creatorTextView.text == "" {
                creatorTextView.textColor = .lightGray
                creatorTextView.text = "Creator"
            }
        }
        else if textView == blurbTextView {
            if blurbTextView.text == "" {
                blurbTextView.textColor = .lightGray
                blurbTextView.text = "Blurb"
            }
        }
    }
}
    
    extension PostViewController: UIPickerViewDataSource, UIPickerViewDelegate {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == categoryPicker{
                return 4
            }
            else {
                return 101
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == categoryPicker{
                return categories[row]
            }
            else {
                return "\(Double(row)/10.0)"
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            
            var pickerLabel = view as? UILabel
            if (pickerLabel == nil)
            {
                pickerLabel = UILabel()
                
                pickerLabel?.font = UIFont(name: "OpenSans-Bold", size: 16)
                pickerLabel?.textAlignment = NSTextAlignment.center
            }
            if pickerView == categoryPicker {
                pickerLabel?.text = categories[row]
                pickerLabel?.textColor = categoryColors[row]
            }
            else {
                pickerLabel?.text = "\(Double(row)/10.0)"
                pickerLabel?.textColor = .red
            }
            return pickerLabel!
        }
        
    }
