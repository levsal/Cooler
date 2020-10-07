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
    
    var posts : [Post] = []
    
    @IBOutlet weak var feedTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.register(UINib(nibName: "AddFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddFriendsTableViewCell")
        feedTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        feedTableView.dataSource = self
        
        feedTableView.separatorColor = UIColor.clear
        
        //Create Friends List
        getFriends()
        
        
        
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
                        if let friend = data["email"] {
                            self.friends.append(friend as! String)
                        }
                    }
                    self.getPosts()
                }
            }
        }
    }
    
    func getPosts() {
        print("getting posts for \(self.friends)")

        
        for friend in friends {
            self.posts = []
            db.collection("\(friend)_Posts").order(by: "date").addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore, \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let date = data["date"], let text = data["text"] {
                                let post = Post(user: friend, date: (date as! Double), postText: (text as! String))
                                self.posts.append(post)
//                                print(self.posts)
//                                print("Reloading...")
                                self.feedTableView.reloadData()
                            }
                        }
                        
                    }
                }
                
            }
            
        }
   
        
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            //ADD FRIENDS HEADER
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendsTableViewCell", for: indexPath) as! AddFriendsTableViewCell
            cell.parentVC = self
            return cell
        }
        
        else {
            //POSTS
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsPostsTableViewCell", for: indexPath) as! FriendsPostsTableViewCell
            
            print(indexPath.row)
            print(posts)
            
            let email = cell.userEmail
            let user = posts[indexPath.row-1].user
            email!.setTitle(user, for: .normal)

            let content = posts[indexPath.row-1].postText
            cell.friendsPostTextView.text = content
                        
            return cell
        }
    }
    
    
}
