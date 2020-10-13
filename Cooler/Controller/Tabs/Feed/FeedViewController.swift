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
    
    var categoryColorsSingular = ["Album": #colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1), "Movie": #colorLiteral(red: 0.8735565543, green: 0.705497086, blue: 0.1316877007, alpha: 1), "TV Show": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1), "Book": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    var categoryColorsSingularPale = ["Album": #colorLiteral(red: 0.7195122838, green: 0.7771759033, blue: 0.9829060435, alpha: 1), "Movie": #colorLiteral(red: 0.8376982212, green: 0.8472841382, blue: 0.4527434111, alpha: 1), "TV Show": #colorLiteral(red: 0.6429418921, green: 0.8634710908, blue: 0.6248642206, alpha: 1), "Book": #colorLiteral(red: 0.886295557, green: 0.6721803546, blue: 0.6509570479, alpha: 1), "N/A": #colorLiteral(red: 0.3980969191, green: 0.4254524708, blue: 0.4201924801, alpha: 1)]

    var categoryIcons = ["Album": UIImage(systemName: "music.note"), "Movie": UIImage(systemName: "film"), "TV Show": UIImage(systemName: "tv"), "Book": UIImage(systemName: "book"), "N/A": UIImage(systemName: "scribble")]
    
    var postOpen : [String: Bool] = [:]
        
    @IBOutlet weak var feedTableView: PositionCorrectingTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.register(UINib(nibName: "AddFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddFriendsTableViewCell")
        feedTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        feedTableView.register(UINib(nibName: "PostDetailView", bundle: nil), forCellReuseIdentifier: "PostDetailView")
        
        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        feedTableView.separatorColor = UIColor.clear
        
        //Create Friends List
        getFriends()
        
        
    }
    func assignValuesToPostOpen() {
        for post in posts {
            postOpen[post.postText] = false
        }
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
                    print(self.friends)
                    self.getPosts()
                }
            }
        }
    }
    
    func getPosts() {
//        print("getting posts for \(self.friends)")
        print(friends)
        self.posts = []

        for friend in friends {
            db.collection("\(friend)_Posts").order(by: "date").addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore, \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let date = data["date"], let text = data["text"], let category = data["category"], let creator = data["creator"] {
                                
                                let post = Post(user: friend, date: (date as! Double), postText: (text as! String), category: category as! String, creator: creator as! String)
                                
                                self.posts.append(post)
                                self.assignValuesToPostOpen()

                            }
                        }
                        self.feedTableView.reloadData()

                    }
                }
                
            }
            
        }

   
        
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = Bundle.main.loadNibNamed("AddFriendsTableViewCell", owner: self, options: nil)?.first as! AddFriendsTableViewCell
            cell.parentVC = self
            return cell
        }
        
        else if section <= posts.count - 1{
            let cell = Bundle.main.loadNibNamed("FriendsPostsTableViewCell", owner: self, options: nil)?.first as! FriendsPostsTableViewCell
            cell.parentFeedVC = self
            
            
                let user = posts[section-1].user
                cell.userEmail!.setTitle(user, for: .normal)
                
                let postName = posts[section-1].postText
                cell.friendsPostTextView.text = postName
                
                let creator = posts[section-1].creator
                cell.creatorTextView.text = creator
                
                cell.categoryIcon.image = categoryIcons[posts[section-1].category]!!
                
                //Color Corresponding to Category
                cell.friendsPostTextView.backgroundColor = categoryColorsSingular[posts[section-1].category]
                cell.creatorTextView.backgroundColor = categoryColorsSingularPale[posts[section-1].category]

            return cell
        }
        else {
            return UIView()
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return posts.count + 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }
        
        else if section <= posts.count - 1 {
            let post = posts[section-1]
            if postOpen[post.postText] == false{
                return 0
            }
            else {
                return 1
            }
        }
        
        //WHITE SPACE
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "PostDetailView")!
        return cell

    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    
}

