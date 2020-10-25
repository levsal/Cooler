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
    
    var parentProfileVC : ProfileViewController?
    var parentFeedVC : FeedViewController?
    var parentFindFriendsVC : FindFriendsViewController?
    
    var sectionNumber = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editStack.isHidden = true
//        editButton.isHidden = true
       
//        editButton.isHidden = false
        
        profilePic.layer.borderWidth = 2
        profilePic.layer.cornerRadius = profilePic.frame.height/5
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func profileTriggerPressed(_ sender: UIButton) {
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
        
        postVC.postTextView.textColor = .black
        postVC.postTextView.text = friendsPostTextView.text
        
        postVC.creatorTextView.textColor = .black
        postVC.creatorTextView.text = creatorTextView.text
        
        
        
//        postVC.categoryPicker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
//        postVC.ratingPicker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
        
        
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
        if sender.titleLabel?.text == "Confirm"{
            print("\(String(describing: Auth.auth().currentUser?.email))_Posts")
            parentProfileVC?.db.collection("\((Auth.auth().currentUser?.email!)!)_Posts").document(friendsPostTextView.text).delete()
        }
    }
    
    
}


