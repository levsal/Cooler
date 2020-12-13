//
//  FriendsPostsTableViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/30/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase

class FriendsPostsTableViewCell: UITableViewCell {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userEmail: UIButton!
    @IBOutlet weak var dateString: UILabel!
    @IBOutlet weak var friendsPostTextView: UITextView!
    @IBOutlet weak var creatorTextView: UITextView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var listButton: UIButton!
    @IBOutlet weak var editStack: UIStackView!
    @IBOutlet weak var titleStack: UIStackView! 
    @IBOutlet var userView: UIView!
    @IBOutlet var stackHeight: NSLayoutConstraint!
    @IBOutlet var iconOffset: NSLayoutConstraint!
    @IBOutlet var iconHeight: NSLayoutConstraint!
    @IBOutlet var iconWidth: NSLayoutConstraint!

    
    
    var date : Double?
    var category : String?
    var rating : Double?
    var email : String?
    var icon : UIImage?
    var blurb : String?
    
    var parentProfileVC : ProfileViewController?
    var parentFeedVC : FeedViewController?
    var parentFindFriendsVC : FindFriendsViewController?
    var parentUserSettingsVC : UserSettingsViewController?
    var parentListVC : ListViewController?
    
    
    @IBOutlet var stackToTop: NSLayoutConstraint!
    @IBOutlet var stackToBottom: NSLayoutConstraint!
    
    var sectionNumber = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editStack.isHidden = true
        editButton.isHidden = true
        
        listButton.isHidden = true
        
        userView.layer.borderWidth = 3
        userView.layer.borderColor = #colorLiteral(red: 0.1618016958, green: 0.1618359685, blue: 0.1617971659, alpha: 1)
//        userView.layer.cornerRadius = 5
//        userView.layer.borderColor = #colorLiteral(red: 0.174927026, green: 0.1749634147, blue: 0.1749222279, alpha: 1)

//        titleStack.layer.borderWidth = 2
//        titleStack.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        friendsPostTextView.layer.cornerRadius = 10
        

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func profileTriggerPressed(_ sender: UIButton) {
        parentFeedVC!.segueFriendEmail = email

        parentFeedVC?.performSegue(withIdentifier: "FeedToProfile", sender: parentFeedVC)
    }
    
    
    
    
    
    @IBAction func postTriggerPressed(_ sender: UIButton) {
        let work = friendsPostTextView.text
        
        //PROFILE
        if parentProfileVC?.postOpen[work!] == false {
            parentProfileVC?.postOpen[work!] = true
            
            parentProfileVC?.postTableView.reloadData()
            parentProfileVC?.postTableView.layoutIfNeeded()
           
        }
        else if parentProfileVC?.postOpen[work!] == true{
            parentProfileVC?.postOpen[work!] = false
                        
            parentProfileVC?.postTableView.reloadData()
            parentProfileVC?.postTableView.layoutIfNeeded()

        }
        
        //FEED
        if parentFeedVC?.postOpen[work!] == false{
            parentFeedVC?.postOpen[work!] = true

            parentFeedVC?.feedTableView.reloadData()
            parentFeedVC?.feedTableView.layoutIfNeeded()

        }
        else if parentFeedVC?.postOpen[work!] == true{
            parentFeedVC?.postOpen[work!] = false
                        
            parentFeedVC?.feedTableView.reloadData()
            parentFeedVC?.feedTableView.layoutIfNeeded()
            
        }

        
        self.layoutIfNeeded()
        parentProfileVC?.postTableView.setContentOffset((parentProfileVC?.postTableView.offset)!, animated: false)
        parentFeedVC?.feedTableView.setContentOffset((parentFeedVC?.feedTableView.offset)!, animated: false)
        
        
        //User Settings
        if parentUserSettingsVC != nil  {
            if categoryIcon.image != UIImage(systemName: "checkmark") {
                categoryIcon.image = UIImage(systemName: "checkmark")
                parentUserSettingsVC!.parentProfileVC?.categories.append(friendsPostTextView.text)
                db.collection("Users").document((Auth.auth().currentUser?.email!)!).updateData(["Artforms" : parentUserSettingsVC!.parentProfileVC!.categories])
            }
            else if (parentUserSettingsVC?.parentProfileVC?.categories.count)!>1 {
                categoryIcon.image = icon
                let exitingCategoryIndex = parentUserSettingsVC?.parentProfileVC?.categories.firstIndex(of: friendsPostTextView.text)
                parentUserSettingsVC!.parentProfileVC?.categories.remove(at: exitingCategoryIndex!)
                db.collection("Users").document((Auth.auth().currentUser?.email!)!).updateData(["Artforms" : parentUserSettingsVC!.parentProfileVC!.categories])
            }
            parentUserSettingsVC?.parentProfileVC?.selectedCategories = []
            parentUserSettingsVC?.parentProfileVC?.resetSelecteds = true
            parentUserSettingsVC?.parentProfileVC?.resetSelectedCategories()
            parentUserSettingsVC?.parentProfileVC?.categoryCollectionView.reloadData()
        }
        
        
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        sender.isHidden = true
        editStack.isHidden = false
    }
   
    @IBAction func editPressed(_ sender: UIButton) {
        let postVC: PostViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "postViewController") as! PostViewController
        postVC.delegate = parentProfileVC
        parentProfileVC?.present(postVC, animated: true)
        postVC.delegate = parentProfileVC
        
        
        postVC.preservedPostText = friendsPostTextView.text
        postVC.preservedDate = date
        
        postVC.postTextView.textColor = .white
        postVC.postTextView.text = friendsPostTextView.text
        
        postVC.creatorTextView.textColor = .white
        postVC.creatorTextView.text = creatorTextView.text
        
        
        print(postVC.categoryPickerDictionary)
        for category in 0...postVC.categories.count-1 {
            postVC.categoryPickerDictionary[postVC.categories[category]] = category
        }
        for rating in 0...100 {
            postVC.ratingPickerDictionary[Double(rating)/10.0] = rating
        }
        if let categoryInt = postVC.categoryPickerDictionary[category!] {
            postVC.categoryPicker.selectRow(categoryInt, inComponent: 0, animated: false)

        }

        if let ratingInt = postVC.ratingPickerDictionary[rating!] {
            print(ratingInt)
            postVC.ratingPicker.selectRow(ratingInt, inComponent: 0, animated: false)
        }
        
        
        for post in parentProfileVC!.posts {
            if post.postText == friendsPostTextView.text {
                postVC.blurbTextView.textColor = .white
                postVC.blurbTextView.text = post.blurb
            }
        }
        
        postVC.postButton.setTitle("Finish Edit", for: .normal)
        
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Delete"{
            sender.setTitle("Confirm", for: .normal)
        }
        
        else if sender.titleLabel?.text == "Confirm"{
            print("\(String(describing: Auth.auth().currentUser?.email))_Posts")
            parentProfileVC?.db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("Posts").document(friendsPostTextView.text).delete()
        }
    }
    
    @IBAction func addToListPressed(_ sender: UIButton) {
       
        if sender.imageView!.image == UIImage(systemName: "plus") {
            print("WASTANG")

            db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("List")
                .document(friendsPostTextView.text).setData(["text": friendsPostTextView.text, "date": -Date().timeIntervalSince1970, "category": category as! String, "creator": creatorTextView.text,"blurb" : blurb, "rating": rating as! Double, "dateString" : dateString.text, "user" : userEmail.titleLabel!.text as! String])
            sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
        else if sender.imageView!.image == UIImage(systemName: "checkmark") {
            
            print("WASMARK")

            db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("List").document(friendsPostTextView.text).delete()
            
//            let exitingPostIndex = parentFeedVC!.list.firstIndex(of: Post(userEmail: nil, username: nil, profilePicURL: nil, date: nil, dateString: nil, postText: friendsPostTextView.text, category: category, creator: nil, blurb: nil, rating: nil, fromUser: nil))!
//            
//            parentFeedVC!.list.remove(at: exitingPostIndex)
            sender.setImage(UIImage(systemName: "plus"), for: .normal)

        }
        
    }

    
    
}


