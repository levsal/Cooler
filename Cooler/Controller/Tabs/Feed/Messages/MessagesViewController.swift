//
//  MessagesViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/12/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let db = Firestore.firestore()
    var friends : [Friend] = []
    var segueURL = ""
    var segueName = ""
    
    @IBOutlet var convosTableView: UITableView!
    @IBOutlet var messagesSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        convosTableView.register(UINib(nibName: "FindFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FindFriendsTableViewCell")
        convosTableView.dataSource = self
        convosTableView.delegate = self
        messagesSearchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessagesToConvo" {
            let convoVC = segue.destination as! ConvoViewController
            convoVC.imageString = segueURL
            convoVC.friend = segueName
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFriendsTableViewCell") as! FindFriendsTableViewCell
        cell.parentMessagesVC = self
        
        cell.name.text = friends[indexPath.row].name
        cell.bio.text = friends[indexPath.row].bio
        
        if friends[indexPath.row].picURL != nil {
            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2
            cell.profilePic.loadAndCacheImage(urlString: (friends[indexPath.row].picURL)!)
        }
        else {
            cell.profilePic.image = UIImage(systemName: "person.fill")
        }

        return cell
    }
    
    
}

extension MessagesViewController : UISearchBarDelegate {
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
                                let bio = data["bio"] as? String

                                let index = name.index(name.startIndex, offsetBy: textLength)
                                let nameSnippet = name.prefix(upTo: index)

                                if nameSnippet == searchText {
                                    self.friends.append(Friend(email: email,
                                                               name: name,
                                                               date: date,
                                                               picURL: picURL,
                                                               bio: bio))
                                    print(nameSnippet)
                                }
                            }
                        }
                    }
                    print(self.friends)
                    self.convosTableView.reloadData()
                }
            }
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let profileVC = segue.destination as! ProfileViewController
//
//        if segue.identifier == "SearchToProfile" {
//           print(existingFriends)
//            for friend in existingFriends {
//                if segueEmail == friend.email{
//                    print("Googoogaga")
//                    profileVC.friendStatusButton = "Remove Friend"
//                    profileVC.friendStatusColor = #colorLiteral(red: 1, green: 0.2305461764, blue: 0.1513932645, alpha: 1)
//                }
//            }
//            profileVC.isHost = false
//            profileVC.email = segueEmail
//            profileVC.signOutButtonTitle = "Back To Search"
//            profileVC.postButton.image = nil
//            profileVC.postButton.title = ""
//            profileVC.addFriendHidden = false
//        }
//    }
    
    
}
