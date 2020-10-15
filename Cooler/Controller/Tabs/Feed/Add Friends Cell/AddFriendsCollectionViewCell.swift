//
//  AddFriendsCollectionViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/20/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class AddFriendsCollectionViewCell: UICollectionViewCell {
    
    var email = ""
    @IBOutlet weak var userEmail: UIButton!
    
    weak var parentCell : AddFriendsTableViewCell?
    
    let profileVC: ProfileViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    @IBAction func userEmailPressed(_ sender: UIButton) {
        //Upon showing popup, change user email and reperform necessary functions
        setUpProfile()
    }
    
    func setUpProfile() {
        
        profileVC.isHost = false
        profileVC.getName(user: email) //Determines usernameString
        
        parentCell?.parentVC?.present(profileVC, animated: true)
        
        profileVC.username.text = profileVC.usernameString
        profileVC.addFriendButton.isHidden = false

        profileVC.email = email
        
        
        
        profileVC.loadPosts(from: profileVC.selectedCategories)
        profileVC.getFriends(of: (email))
    }
    
}
