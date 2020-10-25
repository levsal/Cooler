//
//  FindFriendsViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 10/15/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class FindFriendsViewController: UIViewController {

    let db = Firestore.firestore()
    
    var existingFriends : [Friend] = []
    var friends : [Friend] = []
    
    var segueEmail = ""
    var segueName = ""
    
    @IBOutlet weak var usersSearchBar: UISearchBar!
    
    @IBOutlet weak var usersTableView: PositionCorrectingTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFriends()
        
        usersSearchBar.delegate = self
        usersTableView.dataSource = self
        usersTableView.delegate = self

        usersTableView.register(UINib(nibName: "FindFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FindFriendsTableViewCell")
        
        usersTableView.separatorColor = .clear
    }

    
    func getFriends() {
        
        db.collection("\(Auth.auth().currentUser!.email!)_Friends").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.friends = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let friendEmail = data["email"], let friendName = data["name"] {
                            self.existingFriends.append(Friend(email: friendEmail as? String, name: friendName as? String))
                        }
                    }
                }
            }
        }
    }
}


extension FindFriendsViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let textLength = searchText.count
        print(textLength)
        
        db.collection("Users").order(by: "name").addSnapshotListener { (querySnapshot, error) in
            
            if let e = error {
                print("Error finding friend, \(e)")
            }
            else {
                self.friends = []
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let name = data["name"] as? String,
                           let email = data["email"] as? String,
                           let date = data["date"] as? Double
                           {
                            if name.count >= textLength && textLength > 0 {
                                
                                let picURL = data["picURL"] as? String

                                let index = name.index(name.startIndex, offsetBy: textLength)
                                let nameSnippet = name.prefix(upTo: index)

                                if nameSnippet == searchText {
                                    self.friends.append(Friend(email: email,
                                                               name: name,
                                                               date: date,
                                                               picURL: picURL))
                                    print(nameSnippet)
                                }
                            }
                        }
                    }
                    print(self.friends)
                    self.usersTableView.reloadData()
                }
            }
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileVC = segue.destination as! ProfileViewController
        if segue.identifier == "SearchToProfile" {
           print(existingFriends)
            for friend in existingFriends {
                if segueEmail == friend.email{
                    print("Googoogaga")
//                    profileVC.addFriendButton.setTitle("Remove Friend", for: .normal)
                }
            }
            profileVC.isHost = false
            profileVC.email = segueEmail
            profileVC.loadProfilePage(email: profileVC.email)//
            profileVC.signOutButtonTitle = "Back To Search"
            profileVC.addFriendHidden = false
        }
    }
}

extension FindFriendsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = usersTableView.dequeueReusableCell(withIdentifier: "FindFriendsTableViewCell", for: indexPath) as! FindFriendsTableViewCell

        cell.parentFindFriendsVC = self
        cell.name.text = friends[indexPath.row].name
        if friends[indexPath.row].picURL != nil {
            cell.profilePic.loadAndCacheImage(urlString: (friends[indexPath.row].picURL)!)

        }
        
        return cell
    }
    
    
}
