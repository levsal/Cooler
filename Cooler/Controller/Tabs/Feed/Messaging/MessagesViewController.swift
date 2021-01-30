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
    var existingConvos : [Friend] = []
    var friends : [Friend] = []
    
    var segueCurrentUserName = ""
    var segueURL = ""
    var segueName = ""
    var segueEmail = ""
    
    @IBOutlet var convosTableView: UITableView!
    @IBOutlet var messagesSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        
        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        messagesSearchBar.backgroundColor = #colorLiteral(red: 0.1321208775, green: 0.1321504712, blue: 0.1321169734, alpha: 1)
        messagesSearchBar.barTintColor = #colorLiteral(red: 0.06139858812, green: 0.06141700596, blue: 0.06139617413, alpha: 1)

        convosTableView.register(UINib(nibName: "FindFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FindFriendsTableViewCell")
        convosTableView.dataSource = self
        convosTableView.delegate = self
        messagesSearchBar.delegate = self
        
        getCurrentUserName()
        getConvos()
    }
    
    func getCurrentUserName() {
        
    }
    
    func getConvos() {
        db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("Messages").addSnapshotListener { (querySnapshot, error) in
            self.existingConvos = []
            if let e = error {
                print("Error loading conversations, \(e)")
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let emailID = doc.documentID
                        print(emailID)
                        let data = doc.data()
                        if let email = data["email"],
                           let name = data["name"],
                           let picURL = data["picURL"],
                           let lastMessageTime = data["lastMessageTime"] {
                            self.existingConvos.append(Friend(email: email as? String,
                                                         name: name as? String,
                                                         date: nil,
                                                         picURL: picURL as? String,
                                                         bio: nil,
                                                         lastMessageTimeString: lastMessageTime as? String))
                            
                        }
                    }
                    self.convosTableView.reloadData()
                    
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessagesToConvo" {
            let convoVC = segue.destination as! ConvoViewController
           
            convoVC.currentUserName = segueCurrentUserName

            convoVC.imageString = segueURL
            convoVC.friend = segueName
            convoVC.friendEmail = segueEmail
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friends == [] {
            return existingConvos.count
        }
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFriendsTableViewCell") as! FindFriendsTableViewCell
        cell.parentMessagesVC = self
        
        if friends == [] && existingConvos != [] {
            print("SHOWING EXISTING CONVOS")
            cell.name.text = existingConvos[indexPath.row].name
            cell.bio.text = existingConvos[indexPath.row].lastMessageTimeString
            
            if existingConvos[indexPath.row].picURL != nil {
                cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2
                cell.profilePic.loadAndCacheImage(urlString: (existingConvos[indexPath.row].picURL)!)
            }
            
            return cell
        }


        
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

    
}
