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
    
    var categoryNames = ["Albums", "Movies", "TV Shows", "Books", "Artists", "Songs", "Misc."]

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
                
        cell.categoryIcon.tintColor = K.categoryColorsPlural[categoryNames[section]]
        
        cell.categoryIcon.image = (K.categoryIconsPlural[categoryNames[section]]!)
        cell.icon = (K.categoryIconsPlural[categoryNames[section]]!!)

        cell.friendsPostTextView.text = categoryNames[section]
        
        let title = cell.friendsPostTextView.text
        if parentProfileVC!.categories.contains(title!){
            cell.categoryIcon.image = UIImage(systemName: "checkmark")
        }
        
        switch cell.friendsPostTextView.text {
       
        case "Albums":
            cell.creatorTextView.text = "Artist or Band"
        case "Movies":
             cell.creatorTextView.text = "Genre, e.g Superhero Movie"
        case "TV Shows":
            cell.creatorTextView.text = "Genre, e.g. Teen Drama"
        case "Books":
            cell.creatorTextView.text = "Author"
        case "Artists":
            cell.creatorTextView.text = "Genre, e.g. Folk Band; Pop Singer"
        case "Songs":
             cell.creatorTextView.text = "Artist or Band"
       
       
        default:
            cell.creatorTextView.text = "Creator or Genre"
        }

//            cell.friendsPostTextView.isHidden = false
//            cell.creatorTextView.isHidden = true
//            cell.creatorTextView.text = ""
//
//            cell.userView.isHidden = true
        cell.profilePic.isHidden = true
        cell.userEmail.isHidden = true
        cell.dateString.isHidden = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    



}
