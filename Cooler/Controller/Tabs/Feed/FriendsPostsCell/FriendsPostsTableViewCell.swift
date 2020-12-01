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
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userEmail: UIButton!
    @IBOutlet weak var dateString: UILabel!
    @IBOutlet weak var friendsPostTextView: UITextView!
    @IBOutlet weak var creatorTextView: UITextView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var editButton: UIButton!
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
    
    var parentProfileVC : ProfileViewController?
    var parentFeedVC : FeedViewController?
    var parentFindFriendsVC : FindFriendsViewController?
    
    var sectionNumber = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editStack.isHidden = true
        editButton.isHidden = true
        
//        titleStack.layer.cornerRadius = 10
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
        if parentProfileVC?.postOpen[work!] == false{
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
        
        
        
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        sender.isHidden = true
        editStack.isHidden = false
    }
   
    @IBAction func editPressed(_ sender: UIButton) {
        let postVC: PostViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "postViewController") as! PostViewController
        
        parentProfileVC?.present(postVC, animated: true)
        postVC.delegate = parentProfileVC
        
        
        postVC.preservedPostText = friendsPostTextView.text
        postVC.preservedDate = date
        
        postVC.postTextView.textColor = .black
        postVC.postTextView.text = friendsPostTextView.text
        
        postVC.creatorTextView.textColor = .black
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
                postVC.blurbTextView.textColor = .black
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
            parentProfileVC?.db.collection("\((Auth.auth().currentUser?.email!)!)_Posts").document(friendsPostTextView.text).delete()
        }
    }
    
    
}


