//
//  UserSettingsViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/1/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class UserSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var parentProfileVC : ProfileViewController?
    
    @IBOutlet var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        
        settingsTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")

    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return K.categoryColorsPlural.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = Bundle.main.loadNibNamed("FriendsPostsTableViewCell", owner: self, options: nil)?.first as! FriendsPostsTableViewCell
        cell.parentUserSettingsVC = self
                
        cell.categoryIcon.tintColor = K.categoryColorsPlural[K.categoryNames[section]]
        
        cell.categoryIcon.image = (K.categoryIconsPlural[K.categoryNames[section]]!)
        cell.icon = (K.categoryIconsPlural[K.categoryNames[section]]!!)

        cell.friendsPostTextView.text = K.categoryNames[section]
        
        let title = cell.friendsPostTextView.text
        if parentProfileVC!.categories.contains(title!){
            cell.categoryIcon.image = UIImage(systemName: "checkmark")
        }
        
        cell.creatorTextView.text = K.subheadingDictionary[cell.friendsPostTextView.text]

        cell.profilePic.isHidden = true
        cell.userEmail.isHidden = true
        cell.dateString.isHidden = true
        
        cell.friendsPostTextView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.friendsPostTextView.layer.cornerRadius = cell.friendsPostTextView.frame.height/4.5
        
        cell.creatorTextView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cell.creatorTextView.layer.cornerRadius = cell.friendsPostTextView.frame.height/4.5
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
