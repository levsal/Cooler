//
//  AddFriendsCollectionViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/20/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class AddFriendsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userEmail: UIButton!
    
    weak var parentCell : AddFriendsTableViewCell?
    
    let profileVC: ProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
    
    
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
        parentCell?.parentVC?.present(profileVC, animated: true)
        profileVC.userEmail.text = userEmail.titleLabel?.text!
        profileVC.addFriendButton.isHidden = false
        profileVC.loadPosts(from: profileVC.selectedCategories)
        profileVC.getFriends(of: (userEmail.titleLabel?.text)!)
    }
    
}
