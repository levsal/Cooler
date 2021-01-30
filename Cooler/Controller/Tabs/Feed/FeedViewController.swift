//
//  FeedViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/12/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class FeedViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var currentUser = ""
    
    var friends : [[String]] = [[]]
    
    var posts : [Post] = []
    
    var list : [Post] = []
    
    @IBOutlet weak var emptyFeedViewLabel: UILabel!
    
    var postOpen : [String: Bool] = [:]
    
    var segueFriendEmail : String?
    
    @IBOutlet weak var feedTableView: PositionCorrectingTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.06139858812, green: 0.06141700596, blue: 0.06139617413, alpha: 1)

        currentUser = (Auth.auth().currentUser?.email)!
        
        feedTableView.register(UINib(nibName: "AddFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddFriendsTableViewCell")
        feedTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        feedTableView.register(UINib(nibName: "PostDetailView", bundle: nil), forCellReuseIdentifier: "PostDetailView")
        
        feedTableView.dataSource = self
        feedTableView.delegate = self
       
        feedTableView.separatorColor = UIColor.clear
        
        //Create Friends List
        getFriends()
        getList()
        
    }
    func assignValuesToPostOpen() {
        for post in posts {
            postOpen[post.postText!] = false
        }
    }
    
    
    func getFriends(){
        db.collection("Users").document((Auth.auth().currentUser?.email)!).collection("Friends").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            //            self.feedTableView.reloadData()
            self.friends = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let friendEmail = data["email"],
                           let friendName = data["name"],
                           let picURL = data["picURL"] {
                            self.friends.append([friendEmail as! String, friendName as! String, picURL as! String])
                        }
                    }
                    
//                    self.feedTableView.reloadData()
                    self.getPosts()
                }
            }
        }
    }
    
    func getPosts() {

        self.posts = []
        
//        self.feedTableView.reloadData()
        
        for friend in friends {
            db.collection("Users").document(friend[0]).collection("Posts").order(by: "date").addSnapshotListener{ [self] (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore, \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        
                        //Remove posts by relevant friend before reloading them
                        for post in self.posts{
                            if post.username == friend[1]{
                                let index = self.posts.firstIndex(of: post)
                                self.posts.remove(at: index!)
                            }
                        }
                        
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let date = data["date"],
                               let dateString = data["dateString"],
                               let text = data["text"],
                               let category = data["category"],
                               let creator = data["creator"],
                               let blurb = data["blurb"],
                               let givenRating = data["rating"] {
                                let post = Post(userEmail: friend[0],
                                                username: friend[1],
                                                profilePicURL: friend[2],
                                                date: (date as! Double),
                                                dateString: dateString as? String,
                                                postText: (text as! String),
                                                category: category as? String,
                                                creator: creator as? String, blurb: blurb as? String, rating: givenRating as? Double)
                                self.posts.append(post)
                                self.assignValuesToPostOpen()
                                self.posts = self.posts.sorted { $0.date! < $1.date! }
                                
                            }
                        }
                        self.feedTableView.reloadData()

                        
                    }
                }
                
            }
            
            
        }
    }
    
    func getList() {
        
        db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("List").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    self.list = []
                    for doc in snapshotDocuments {
                        let data = doc.data()
                       
                        if let title = data["text"],
                           let category = data["category"]{
                            self.list.append(Post(postText: title as! String, category: category as! String))
                        }
                    }
//                    print(self.list)
                }
            }
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeedToProfile" {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.isHost = false
            profileVC.email = segueFriendEmail!
//            profileVC.loadProfilePage(email: segueFriendEmail!)//
            profileVC.signOutButtonTitle = "Feed"
            profileVC.postButton.image = nil
            profileVC.postButton.title = ""
            
            for friend in friends {
                if segueFriendEmail == friend[0]{
                    profileVC.friendStatusButton = "Remove Friend"
                    profileVC.friendStatusColor = #colorLiteral(red: 1, green: 0.2305461764, blue: 0.1513932645, alpha: 1)
                    
                    
                }
            }
            
            profileVC.addFriendHidden = false
        }
    }
    
    
    @IBAction func messagesPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "FeedToMessages", sender: self)
    }
    
    
}

//MARK: - Table View
extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        return 135
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        return 135
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = UIView()
            return cell
        }
        
        else if section <= posts.count{
            let cell = Bundle.main.loadNibNamed("FriendsPostsTableViewCell", owner: self, options: nil)?.first as! FriendsPostsTableViewCell
            
            cell.parentFeedVC = self
            
            cell.profilePic.loadAndCacheImage(urlString: posts[section-1].profilePicURL!)
            
            
            let username = posts[section-1].username
            cell.userEmail!.setTitle(username, for: .normal)
            
            let postName = posts[section-1].postText
            cell.friendsPostTextView.text = postName
//            cell.friendsPostTextView.textColor = K.categoryColorsSingular[posts[section-1].category!]

            
            let creator = posts[section-1].creator
            cell.creatorTextView.text = creator
//            cell.creatorTextView.textColor = K.categoryColorsSingular[posts[section-1].category!]
            
            let dateString = posts[section-1].dateString
            cell.dateString.text = dateString
            
            let blurb = posts[section-1].blurb
            cell.blurb = blurb
            
            cell.email = posts[section-1].userEmail
            
            let category = posts[section-1].category
            cell.category = category
            
            if let image = K.categoryIcons[posts[section-1].category!]! {
                cell.categoryIcon.image = image
            }
            
            let rating = posts[section-1].rating
            cell.rating = rating
            
            
            
            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2
            
            cell.userView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.userView.layer.cornerRadius = cell.userView.frame.height/4.5
            
            cell.creatorTextView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.creatorTextView.layer.cornerRadius = cell.userView.frame.height/4.5

            DispatchQueue.main.async {
                cell.profilePic.loadAndCacheImage(urlString: self.posts[section-1].profilePicURL!)
            }

            
            
//            cell.userView.backgroundColor = K.categoryColorsSingular[posts[section-1].category!]
            let categoryColor = K.categoryColorsSingular[posts[section-1].category!]
            cell.categoryIcon.tintColor = categoryColor
            
//            cell.userView.layer.borderColor = categoryColor?.cgColor
            
            if postOpen[posts[section-1].postText!]! {
                cell.openClosedArrow.image = UIImage(systemName: "chevron.down")
            }
            
            cell.listButton.isHidden = false
            cell.listButton.setImage(UIImage(systemName: "plus"), for: .normal)
            
            if list.contains(Post(userEmail: nil, username: nil, profilePicURL: nil, date: nil, dateString: nil, postText: cell.friendsPostTextView.text, category: cell.category, creator: nil, blurb: nil, rating: nil, fromUser: nil)) {
//                print("IN LIST")
                cell.listButton.setImage(UIImage(systemName: "checkmark"), for: .normal)

            }

            
            
            return cell
        }
        else {
            return UIView()
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if posts.count == 0 {
            emptyFeedViewLabel.isHidden = false
            feedTableView.isHidden = true
        }
        else {
            emptyFeedViewLabel.isHidden = true
            feedTableView.isHidden = false
        }
        
        return posts.count + 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        
        else if section <= posts.count {
            let post = posts[section-1]
            
            if postOpen[post.postText!] == false{
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
        
        if indexPath.section == 0 {
            
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "AddFriendsTableViewCell") as! AddFriendsTableViewCell
            
            cell.parentFeedVC = self
            
            if friends != [[]] {
                cell.fetchUsers()
            }
            
            return cell
        }
        
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "PostDetailView")! as! PostDetailView
        cell.blurbTextView.text = posts[indexPath.section-1].blurb
        cell.ratingValue.text = "\(String(describing: posts[indexPath.section-1].rating!))"
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        else {
            return 120
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        else {
            return 120
            
        }
    }
    
    
}

