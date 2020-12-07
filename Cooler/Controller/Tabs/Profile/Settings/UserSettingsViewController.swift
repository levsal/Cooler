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
    
    var categoryColorsPlural = ["Albums": #colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1),
                                "Movies": #colorLiteral(red: 0.8745098039, green: 0.7058823529, blue: 0.1333333333, alpha: 1),
                                "TV Shows": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1),
                                "Books": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
                                "Artists": #colorLiteral(red: 0.5275336504, green: 0.8038083911, blue: 1, alpha: 1),
                                "Songs" : #colorLiteral(red: 0.7624928355, green: 0.6272898912, blue: 0.9858120084, alpha: 1),
                                "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    var categoryIcons = ["Albums": UIImage(systemName: "music.note"),
                         "Movies": UIImage(systemName: "film"),
                         "TV Shows": UIImage(systemName: "tv"),
                         "Books": UIImage(systemName: "book"),
                         "Artists": UIImage(systemName: "person"),
                         "Songs" : UIImage(systemName: "music.quarternote.3"),
                         "N/A": UIImage(systemName: "scribble")]
    
    
    var categoryNames = ["Albums", "Movies", "TV Shows", "Books", "Artists", "Songs", "N/A"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        
        settingsTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        settingsTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")

    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return categoryColorsPlural.count
        }
        if section == 1 {
            return 1
        }
        print("Googoogaga")
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = Bundle.main.loadNibNamed("SettingsTableViewCell", owner: self, options: nil)?.first as! SettingsTableViewCell
        cell.parentSettingsVC = self
        switch section {
        case 0:
            cell.headerButton.setTitle("Board Categories", for: .normal)
        case 1 :
            cell.headerButton.setTitle("Bio", for: .normal)
        default:
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsPostsTableViewCell") as! FriendsPostsTableViewCell
            cell.parentUserSettingsVC = self
            
            cell.stackToBottom.constant = 20
            
            cell.categoryIcon.tintColor = categoryColorsPlural[categoryNames[indexPath.row]]
            
            cell.categoryIcon.image = (categoryIcons[categoryNames[indexPath.row]]!!)
            cell.icon = (categoryIcons[categoryNames[indexPath.row]]!!)

            cell.friendsPostTextView.text = categoryNames[indexPath.row]
            
            let title = cell.friendsPostTextView.text
            if parentProfileVC!.categories.contains(title!){
                cell.categoryIcon.image = UIImage(systemName: "checkmark")
            }
            
            switch cell.friendsPostTextView.text {
           
            case "Albums":
                cell.creatorTextView.text = "Artist or Band"
            case "Movies":
                 cell.creatorTextView.text = "Director"
            case "TV Shows":
                cell.creatorTextView.text = "Creator or Star"
            case "Books":
                cell.creatorTextView.text = "Author"
            case "Artists":
                cell.creatorTextView.text = "Medium, e.g. singer/songwriter"
            case "Songs":
                 cell.creatorTextView.text = "Artist or Band"
           
           
            default:
                cell.creatorTextView.text = "Creator"
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
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        }
        return 50
    }
    
    



}
