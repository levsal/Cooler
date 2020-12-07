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
    var picURL = ""

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userEmail: UILabel!
    
    weak var parentCell : AddFriendsTableViewCell?
    
    let profileVC: ProfileViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileVC.parentVC = self
        
//        profilePic.layer.borderWidth = 3
//        profilePic.layer.borderColor = #colorLiteral(red: 0.1095183119, green: 0.109544374, blue: 0.1095148847, alpha: 1)
        

    }


    func setUpProfile() {
        profileVC.isHost = false
        profileVC.picFromCell = true
        profileVC.email = email
//        profileVC.getProfilePic()
        profileVC.loadProfilePage(email: email)
        profileVC.picURL = picURL
        
        parentCell?.parentFeedVC!.present(profileVC, animated: true)
                profileVC.addFriendButton.isHidden = false
        profileVC.loadPosts(from: profileVC.selectedCategories)

        profileVC.profilePic.image = profilePic.image
        
    }
    
}
