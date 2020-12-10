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
    
    var categories : [String] = []

    var categoryColors = [#colorLiteral(red: 0.7195122838, green: 0.7771759033, blue: 0.9829060435, alpha: 1), #colorLiteral(red: 0.9840890765, green: 0.9478709102, blue: 0.5600411892, alpha: 1), #colorLiteral(red: 0.7062328458, green: 0.9582253098, blue: 0.6986720562, alpha: 1), #colorLiteral(red: 0.9942241311, green: 0.751460135, blue: 0.7323454618, alpha: 1)]
    var categoryColorsPlural = ["Album": #colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1),
                                "Movie": #colorLiteral(red: 0.8745098039, green: 0.7058823529, blue: 0.1333333333, alpha: 1),
                                "TV Show": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1),
                                "Book": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
                                "Artist": #colorLiteral(red: 0.5275336504, green: 0.8038083911, blue: 1, alpha: 1),
                                "Song" : #colorLiteral(red: 0.7624928355, green: 0.6272898912, blue: 0.9858120084, alpha: 1),
                                "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    
    var selectedCategory : String?
    
    var preservedPostText : String?
    var preservedDate : Double?
    
    var categoryPickerDictionary : [String : Int] = [:]
    var ratingPickerDictionary : [Double : Int] = [:]
    
    @IBOutlet weak var categoryHeader: UILabel!
    @IBOutlet weak var ratingHeader: UILabel!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var ratingPicker: UIPickerView!
    
    //User Input
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var creatorTextView: UITextView!
    @IBOutlet weak var blurbTextView: UITextView!
    
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let categoryString = NSMutableAttributedString.init(string: "Category")
        categoryString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: categoryString.length))
        categoryHeader.attributedText = categoryString
        
        let ratingString = NSMutableAttributedString.init(string: "Rating")
        ratingString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: ratingString.length))
        ratingHeader.attributedText = ratingString
        
        for category in delegate.categories {
            categories.append(String(category.dropLast()))
        }
                
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
        
//        postTextView.layer.borderWidth = 1
//        postTextView.layer.borderColor = UIColor.black.cgColor
//        creatorTextView.layer.borderWidth = 1
//        creatorTextView.layer.borderColor = UIColor.black.cgColor
//        blurbTextView.layer.borderWidth = 1
//        blurbTextView.layer.borderColor = UIColor.black.cgColor
        


        //        postTextView.layer.cornerRadius = postTextView.layer.frame.width/40
    }
    
    //MARK: - Post Pressed
    @IBAction func postButtonPressed(_ sender: UIButton) {
        
            if postTextView.text != "" && postTextView.text != nil &&
                postTextView.text != "Title" &&
                creatorTextView.text != "" &&
                creatorTextView.text != nil &&
                creatorTextView.text != "Creator" &&
                blurbTextView.text != "" &&
                blurbTextView.text != nil &&
                blurbTextView.text != "Blurb" {
                
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
                            
                
//                delegate.appendToArray(post: Post(date: dateReversed, dateString: dateTime, postText: postText!, category: selectedCategory, creator: creatorText!, blurb: blurbText!, rating: givenRating))
                
                if sender.titleLabel?.text == "Post"{
                    db.collection("Users").document(delegate.email).collection("Posts").document(postText!).setData(["text": postText! as String, "date": dateReversed, "category": selectedCategory, "creator": creatorText!,"blurb" : blurbText!, "rating": givenRating, "dateString" : dateTime]){ (error) in
                        
                        if let e = error{
                            print("There was an issue saving data to Firestore, \(e)")
                        }
                    }
                }
                else if sender.titleLabel!.text == "Finish Edit"{
                    if preservedPostText == postText {
                        db.collection("Users").document(delegate.email).collection("Posts").document(preservedPostText!).updateData(["text": postText! as String, "category": selectedCategory, "creator": creatorText!,"blurb" : blurbText!, "rating": givenRating, "dateString" : dateTime]){ (error) in
                            
                            if let e = error{
                                print("There was an issue saving data to Firestore, \(e)")
                            } else{
                                
                            }
                        }
                    }
                    else {
                        db.collection("Users").document(delegate.email).collection("Posts").document(postText!).setData(["text": postText! as String, "date": preservedDate!, "category": selectedCategory, "creator": creatorText!,"blurb" : blurbText!, "rating": givenRating, "dateString" : dateTime]){ (error) in
                            
                            if let e = error {
                                print("There was an issue saving data to Firestore, \(e)")
                            } else{
                                
                            }
                        }
                        db.collection("Users").document(delegate.email).collection("Posts").document(preservedPostText!).delete()
                        
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
        if textView == postTextView, postTextView.text == "Title" {
            postTextView.text = ""
            postTextView.textColor = .white
        }
        else if textView == creatorTextView, creatorTextView.text == "Creator"  {
            creatorTextView.text = ""
            creatorTextView.textColor = .white
        }
        else if textView == blurbTextView, blurbTextView.text == "Blurb"  {
                blurbTextView.text = ""
                blurbTextView.textColor = .white
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == postTextView {
            if postTextView.text == "" {
                postTextView.textColor = .lightGray
                postTextView.text = "Title"
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
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//            if pickerView == categoryPicker{
//                postTextView.backgroundColor = categoryColors[pickerView.selectedRow(inComponent: 0)]
//                creatorTextView.backgroundColor = categoryColors[pickerView.selectedRow(inComponent: 0)]
//                blurbTextView.backgroundColor = categoryColors[pickerView.selectedRow(inComponent: 0)]
//            }


        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == categoryPicker{
                return categories.count
            }
            else {
                return 101
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == categoryPicker {

                categoryPickerDictionary[categories[row]] = row
                print(categoryPickerDictionary)
                return categories[row]
            }
            else {
                ratingPickerDictionary[Double(row)/10.0] = row
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
                pickerLabel?.textColor = categoryColorsPlural[categories[row]]
            }
            else {
                pickerLabel?.text = "\(Double(row)/10.0)"
                pickerLabel?.textColor = #colorLiteral(red: 0, green: 0.5120117664, blue: 0.1549791396, alpha: 1)
            }
            return pickerLabel!
        }
        
    }
