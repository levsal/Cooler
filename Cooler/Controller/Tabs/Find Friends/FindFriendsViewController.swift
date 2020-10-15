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
    
    var friends : [Friend] = []
    
    @IBOutlet weak var usersSearchBar: UISearchBar!
    
    @IBOutlet weak var usersTableView: PositionCorrectingTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersSearchBar.delegate = self
        
        usersTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
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
                        if let name = data["name"] as? String , let email = data["email"] as? String, let date = data["date"] as? Double{
                            if name.count >= textLength && textLength > 0 {
                                let index = name.index(name.startIndex, offsetBy: textLength)
                                let nameSnippet = name.prefix(upTo: index)

                                if nameSnippet == searchText {
                                    self.friends.append(Friend(email: email,
                                                               name: name,
                                                               date: date))
                                    print(nameSnippet)
                                }
                            }
                        }
                    }
                    print(self.friends)
                }
            }
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension FindFriendsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UIView() as! UITableViewCell
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "FriendsPostsTableViewCell", for: indexPath)
    }
    
    
}
