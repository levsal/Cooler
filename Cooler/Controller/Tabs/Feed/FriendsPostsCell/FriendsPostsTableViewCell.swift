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
    
    @IBOutlet var usernameView: UIView!
    
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet var listButton: UIButton!
    @IBOutlet var repostButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    
    @IBOutlet var profileSegueTrigger: UIButton!
    
    @IBOutlet var repostIcon: UIImageView!
    @IBOutlet weak var editStack: UIStackView!
    @IBOutlet weak var titleStack: UIStackView! 
    @IBOutlet var userView: UIView!
    @IBOutlet var stackHeight: NSLayoutConstraint!
    @IBOutlet var iconOffset: NSLayoutConstraint!
    @IBOutlet var iconHeight: NSLayoutConstraint!
    @IBOutlet var iconWidth: NSLayoutConstraint!
    @IBOutlet var openClosedArrow: UIImageView!
    
    
    var date : Double?
    var category : String?
    var rating : Double?
    var email : String?
    var icon : UIImage?
    var blurb : String?
    var alreadyReposted : Bool = false
    var alreadyLiked : Bool = false
    var profilePicURL : String?
    
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
        repostButton.isHidden = true
        likeButton.isHidden = true
        repostIcon.isHidden = true
        usernameView.isHidden = true
        
        userView.backgroundColor = K.tileColor
        friendsPostTextView.backgroundColor = K.tileColor
        creatorTextView.backgroundColor = K.tileColor
        contentView.backgroundColor = K.backgroundColor
      
        userEmail.setTitleColor(K.fontColor, for: .normal)
        friendsPostTextView.textColor = K.fontColor
        creatorTextView.textColor = K.fontColor
        dateString.textColor = K.fontColor
        categoryIcon.tintColor = K.iconColor
        
        repostIcon.tintColor = K.fontColor
        openClosedArrow.tintColor = K.fontColor

//        categoryIcon.layer.borderWidth = 2
//        categoryIcon.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        profilePic.layer.borderWidth = 0.7
//        profilePic.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
//        userView.alpha = 0.5
//        friendsPostTextView.alpha = 0.5
//        creatorTextView.alpha = 0.5
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func profileTriggerPressed(_ sender: UIButton) {
        parentFeedVC?.segueFriendEmail = email
        
        parentFeedVC?.performSegue(withIdentifier: "FeedToProfile", sender: parentFeedVC)
    }
    
    
    
    
    
    @IBAction func postTriggerPressed(_ sender: UIButton) {
        let exactDate = date
        
        //PROFILE
        if parentProfileVC?.postOpen[exactDate!] == false {
            parentProfileVC?.postOpen[exactDate!] = true
            
            parentProfileVC?.postTableView.reloadData()
            parentProfileVC?.postTableView.layoutIfNeeded()
            
        }
        else if parentProfileVC?.postOpen[exactDate!] == true{
            parentProfileVC?.postOpen[exactDate!] = false
            
            parentProfileVC?.postTableView.reloadData()
            parentProfileVC?.postTableView.layoutIfNeeded()
            
        }
        
        //FEED
        if parentFeedVC?.postOpen[exactDate!] == false{
            parentFeedVC?.postOpen[exactDate!] = true
            
            parentFeedVC?.feedTableView.reloadData()
            parentFeedVC?.feedTableView.layoutIfNeeded()
            
        }
        else if parentFeedVC?.postOpen[exactDate!] == true{
            parentFeedVC?.postOpen[exactDate!] = false
            
            parentFeedVC?.feedTableView.reloadData()
            parentFeedVC?.feedTableView.layoutIfNeeded()
            
        }
        
        //LIST
        if parentListVC?.listedOpen[exactDate!] == false{
            parentListVC?.listedOpen[exactDate!] = true
            
            parentListVC?.listTableView.reloadData()
            parentListVC?.listTableView.layoutIfNeeded()
            
        }
        else if parentListVC?.listedOpen[exactDate!] == true{
            parentListVC?.listedOpen[exactDate!] = false
            
            parentListVC?.listTableView.reloadData()
            parentListVC?.listTableView.layoutIfNeeded()
            
        }
        
        self.layoutIfNeeded()
        parentProfileVC?.postTableView.setContentOffset((parentProfileVC?.postTableView.offset)!, animated: false)
        parentFeedVC?.feedTableView.setContentOffset((parentFeedVC?.feedTableView.offset)!, animated: false)
        parentListVC?.listTableView.setContentOffset((parentListVC?.listTableView.offset)!, animated: false)
        
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
        postVC.postButtonWidthConstant = 110
        
        parentProfileVC?.present(postVC, animated: true)
        postVC.delegate = parentProfileVC
        
        
        postVC.preservedPostText = friendsPostTextView.text
        postVC.preservedDate = date
        
        postVC.postTextView.textColor = .white
        postVC.postTextView.text = friendsPostTextView.text
        
        postVC.creatorTextView.textColor = .white
        postVC.creatorTextView.text = creatorTextView.text
        
        
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
        if sender.tintColor == .white {
            sender.tintColor = #colorLiteral(red: 1, green: 0.2564296126, blue: 0.2134288847, alpha: 1)
        }
        
        else {
            print("\(friendsPostTextView.text!)\(date!)")
            parentProfileVC?.db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("Posts").document("\(friendsPostTextView.text!)\(date!)").delete()
            
        }
    }
    
    @IBAction func addToListPressed(_ sender: UIButton) {
        if parentFeedVC != nil {
            if sender.imageView!.image == UIImage(systemName: "plus") {
                sender.tintColor = K.confirmedColor
                db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("List")
                    .document(friendsPostTextView.text).setData(["text": friendsPostTextView.text!, "date": -Date().timeIntervalSince1970, "category": category!, "creator": creatorTextView.text!,"blurb" : blurb!, "rating": rating!, "dateString" : dateString.text!, "user" : userEmail.titleLabel!.text!])
                sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
            }
            else if sender.imageView!.image == UIImage(systemName: "checkmark") {
                sender.tintColor = .darkGray
                db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("List").document(friendsPostTextView.text).delete()
                
                sender.setImage(UIImage(systemName: "plus"), for: .normal)
                
            }
        }
        else if parentListVC != nil {
            for listed in parentListVC!.listeds {
                if listed.postText == friendsPostTextView.text {
                    if let index = parentListVC?.listeds.firstIndex(of: listed){
                        parentListVC?.listeds.remove(at: index)
                    }
                    db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("List").document(listed.postText!).delete()
                    
                }
            }
            parentListVC?.listTableView.reloadData()
            
        }
        
        
    }
    
    
    @IBAction func repostButtonPressed(_ sender: UIButton) {
        let dateReversed = -Date().timeIntervalSince1970
        if alreadyReposted {
            sender.tintColor = K.fontColor
            db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("Posts").document("\(friendsPostTextView.text!)\(date!)").delete()
            alreadyReposted = false
        }
        else if !alreadyReposted {
            sender.tintColor = K.confirmedColor
            if parentListVC != nil{
                for listed in parentListVC!.listeds {
                    if listed.date == date {
                        let dex = parentListVC!.listeds.firstIndex(of: listed)
                        parentListVC!.listeds.remove(at: dex!)
                    }
                }
            }

            db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("List").document("\(friendsPostTextView.text!)\(dateReversed)").delete()
            
            db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("Posts")
                .document("\(friendsPostTextView.text!)\(dateReversed)").setData(
                    ["text": friendsPostTextView.text!,
                     "date": dateReversed,
                     "category": category!,
                     "creator": creatorTextView.text!,
                     "blurb" : blurb!,
                     "rating": rating!,
                     "dateString" : dateString.text!,
                     "user" : userEmail.titleLabel!.text!,
                     "userEmail" : email!,
                     "userURL" : profilePicURL!,
                     "repost" : true])
            alreadyReposted = true
        }
//        parentFeedVC?.feedTableView.reloadData()
//        parentListVC?.listTableView.reloadData()
        
    }
    
    
//    @IBAction func likeButtonPressed(_ sender: UIButton) {
//        if !alreadyLiked {
//            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//            sender.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//            alreadyLiked = true
//        }
//        else if alreadyLiked {
//            
//            sender.setImage(UIImage(systemName: "heart"), for: .normal)
//            sender.tintColor = .darkGray
//            
//            parentProfileVC?.db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("Posts").document(friendsPostTextView.text).collection("Likes").document((Auth.auth().currentUser?.email!)!)
//            
//            alreadyLiked = false
//        }
//        
//        
//    }
    
    
    
}


