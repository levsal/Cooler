//
//  FeedViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/12/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var friends : [String] = []
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var tableViewScanner = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.register(UINib(nibName: "AddFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddFriendsTableViewCell")
        feedTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        feedTableView.dataSource = self
        
        //Create Friends List
        getFriends()
        
        
        
    }
    
    func getFriends() {
        db.collection("\(Auth.auth().currentUser!.email!)_Friends").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            print("\(Auth.auth().currentUser!.email!)_Friends")
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let friend = data["email"] {
                            self.friends.append(friend as! String)
                            print(self.friends)
                        }
                    }
                }
            }
        }
    }
    
    
    
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableViewScanner == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendsTableViewCell", for: indexPath) as! AddFriendsTableViewCell
            cell.parentVC = self
            tableViewScanner += 1
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsPostsTableViewCell", for: indexPath) as! FriendsPostsTableViewCell
            return cell
        }
    }
    
    
}
