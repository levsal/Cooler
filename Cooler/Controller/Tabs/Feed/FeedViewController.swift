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
    let refreshControl = UIRefreshControl()
    
    var currentUser = ""
    
    var friends : [Friend] = []
    
    var posts : [Post] = []
    
    var list : [Post] = []
    var reposts : [Post] = []
    
    @IBOutlet weak var emptyFeedViewLabel: UILabel!
    
    var postOpen : [Double: Bool] = [:]
    
    var segueFriendEmail : String?
    
    var sendingMessage = false
    var postToSend : Post?
    
    @IBOutlet weak var feedTableView: PositionCorrectingTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        feedTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadTableView(_:)), for: .valueChanged)
        refreshControl.tintColor = K.fontColor
        

        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 18)!, NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 1)]

        currentUser = (Auth.auth().currentUser?.email)!
        
        feedTableView.register(UINib(nibName: "AddFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddFriendsTableViewCell")
        feedTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        feedTableView.register(UINib(nibName: "PostDetailView", bundle: nil), forCellReuseIdentifier: "PostDetailView")
        
        feedTableView.dataSource = self
        feedTableView.delegate = self
       
        feedTableView.separatorColor = UIColor.clear
        
        //Create Friends List
        getFriends()
        getListAndReposts()
        setColors()
    }
    
    @objc private func reloadTableView(_ sender: Any) {
        feedTableView.reloadData()
        self.refreshControl.endRefreshing()
//        self.activityIndicatorView.stopAnimating()

    }
    
    func setColors() {
        view.backgroundColor = K.backgroundColor
        feedTableView.backgroundColor = K.backgroundColor
    }
    
    func assignValuesToPostOpen() {
        for post in posts {
            postOpen[post.date!] = false
        }
    }
    
    
    func getFriends(){
        db.collection("Users").document((Auth.auth().currentUser?.email)!).collection("Friends").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.friends = []
            K.friends = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let friendEmail = data["email"],
                           let friendName = data["name"],
                           let picURL = data["picURL"] {

                            self.friends.append(Friend(email: friendEmail as? String,
                                                       name: friendName as? String,
                                                       date: nil,
                                                       picURL: picURL as? String,
                                                       bio: nil,
                                                       lastMessageTimeString: nil))
                        }
                    }
                    
                    self.getPosts()
                    K.friends = self.friends
                }
            }
        }
    }
    
    func getPosts() {

        self.posts = []
        
        
        for friend in friends {
            db.collection("Users").document(friend.email!).collection("Posts").order(by: "date").addSnapshotListener{ [self] (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore, \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        
                        //Remove posts by relevant friend before reloading them
                        for post in self.posts{
                            if post.username == friend.name{
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
                                if let reposted = data["repost"], let user = data["user"], let userEmail = data["userEmail"], let url = data["userURL"]  {
                                    let post = Post(userEmail: friend.email,
                                                    username: friend.name,
                                                    profilePicURL: friend.picURL,
                                                    date: (date as! Double),
                                                    dateString: dateString as? String,
                                                    postText: (text as! String),
                                                    category: category as? String,
                                                    creator: creator as? String,
                                                    blurb: blurb as? String,
                                                    rating: givenRating as? Double,
                                                    repost: reposted as? Bool,
                                                    fromUser: user as? String,
                                                    fromUserEmail: userEmail as? String,
                                                    userURL: url as? String)
                                    self.posts.append(post)
                                }
                                else {
                                    let post = Post(userEmail: friend.email,
                                                    username: friend.name,
                                                    profilePicURL: friend.picURL,
                                                    date: (date as! Double),
                                                    dateString: dateString as? String,
                                                    postText: (text as! String),
                                                    category: category as? String,
                                                    creator: creator as? String,
                                                    blurb: blurb as? String,
                                                    rating: givenRating as? Double)
                                    self.posts.append(post)

                                }
                                
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
    
    func getListAndReposts() {
        
        //LIST
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
//                            print(Post(postText: title as! String, category: category as! String))
                        }
                    }
                }
            }
        }
        
        //REPOSTS
        db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("Posts").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    self.reposts = []
                    for doc in snapshotDocuments {
                        let data = doc.data()
                       
                        if let repost = data["repost"],
                           let title = data["text"],
                           let user = data["user"]{

                            self.reposts.append(Post(postText: (title as! String), repost: (repost as! Bool), fromUser: (user as! String)))
//                            print(Post(postText: (title as! String), repost: (repost as! Bool), fromUser: (user as! String)))
                        }
                    }
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
            profileVC.signOutButtonTitle = "Back to Feed"
            profileVC.postButton.image = nil
            profileVC.postButton.title = ""
            
            for friend in friends {
                if segueFriendEmail == friend.email{
                    profileVC.friendStatusButton = "Remove Friend"
                    profileVC.friendStatusColor = #colorLiteral(red: 1, green: 0.2305461764, blue: 0.1513932645, alpha: 1)
                }
            }
            
            profileVC.addFriendHidden = false
        }
        
        
        else if segue.identifier == "FeedToMessages" {
            let messagesVC = segue.destination as! MessagesViewController
            if sendingMessage == true {
                messagesVC.postToSend = postToSend
                messagesVC.sendPostViewHidden = false
            }
            else {
                messagesVC.sendPostViewHidden = true
            }

        }
    }
    
    
    @IBAction func messagesPressed(_ sender: UIButton) {
        sendingMessage = true
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
//        return UIScreen.main.bounds.width - 10
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        return 135
//        return UIScreen.main.bounds.width - 10
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
            cell.userEmail.setTitle(username, for: .normal)
//            if username != nil {
//                let attributedString = NSMutableAttributedString.init(string: username!)
//                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
//                cell.userEmail!.setAttributedTitle(attributedString, for: .normal)
//            }
//            
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
            
            let date = posts[section-1].date
            cell.date = date
            
            let url = posts[section-1].profilePicURL
            cell.profilePicURL = url
            
            
            
            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2
            
            cell.userView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.userView.layer.cornerRadius = cell.userView.frame.height/4.5
            
            cell.usernameView.isHidden = false
            cell.usernameView.layer.cornerRadius = cell.userView.layer.cornerRadius
            
//            cell.usernameView.backgroundColor = K.categoryColorsSingular[posts[section-1].category!]
            cell.creatorTextView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.creatorTextView.layer.cornerRadius = cell.userView.frame.height/4.5

            DispatchQueue.main.async {
                if let url = self.posts[section-1].profilePicURL {
                    cell.profilePic.loadAndCacheImage(urlString: url)
                }
            }

            
            
//            cell.userView.backgroundColor = K.categoryColorsSingular[posts[section-1].category!]
            if K.colorsFromDictionary {
                let categoryColor = K.categoryColorsSingular[posts[section-1].category!]
                cell.categoryIcon.tintColor = categoryColor
            }
            
            
//            cell.userView.layer.borderColor = categoryColor?.cgColor
            
            if postOpen[posts[section-1].date!]! {
                cell.openClosedArrow.image = UIImage(systemName: "chevron.down")
            }

            cell.listButton.isHidden = false
            cell.repostButton.isHidden = false
//            cell.likeButton.isHidden = false
            
            cell.listButton.setImage(UIImage(systemName: "plus"), for: .normal)
            
//            print(list)
            if list.contains(Post(userEmail: nil, username: nil, profilePicURL: nil, date: nil, dateString: nil, postText: cell.friendsPostTextView.text, category: cell.category, creator: nil, blurb: nil, rating: nil, fromUser: nil)) {
                cell.listButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                cell.listButton.tintColor = K.confirmedColor
            }
            
            if reposts.contains(Post(userEmail: nil, username: nil, profilePicURL: nil, date: nil, dateString: nil, postText: cell.friendsPostTextView.text, category: nil, creator: nil, blurb: nil, rating: nil, repost: true, fromUser: username)) {
                cell.repostButton.tintColor = K.confirmedColor
                cell.alreadyReposted = true
            }
            
            if let repost = posts[section-1].repost {
                if repost {
                    cell.repostIcon.isHidden = false
                }
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
            
            if postOpen[post.date!] == false{
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
            if friends != [] {
                cell.fetchUsers()
            }
            
            
            return cell
        }
        
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "PostDetailView")! as! PostDetailView
        cell.feedVC = self

        cell.blurbTextView.text = posts[indexPath.section-1].blurb
        cell.ratingValue.text = "\(String(describing: posts[indexPath.section-1].rating!))"
        
        cell.category.setTitle(posts[indexPath.section-1].category!, for: .normal)
        if posts[indexPath.section-1].fromUser != nil {
            cell.separator.isHidden = false
            cell.repostStack.isHidden = false
            cell.repostDetail.setTitle(posts[indexPath.section-1].fromUser!, for: .normal)
        }
        else {
            cell.separator.isHidden = true
            cell.repostStack.isHidden = true
        }
        
        cell.fromUserEmail = posts[indexPath.section-1].fromUserEmail
        cell.userURL = posts[indexPath.section-1].userURL
        
        cell.packagedPost = Post(userEmail: posts[indexPath.section-1].userEmail,
                                 username: posts[indexPath.section-1].username,
                                 profilePicURL: posts[indexPath.section-1].profilePicURL,
                                 date: posts[indexPath.section-1].date,
                                 dateString: posts[indexPath.section-1].dateString,
                                 postText: posts[indexPath.section-1].postText,
                                 category: posts[indexPath.section-1].category,
                                 creator: posts[indexPath.section-1].creator,
                                 blurb: posts[indexPath.section-1].blurb,
                                 rating: posts[indexPath.section-1].rating,
                                 repost: posts[indexPath.section-1].repost,
                                 fromUser: posts[indexPath.section-1].fromUser,
                                 fromUserEmail: posts[indexPath.section-1].fromUserEmail,
                                 userURL: posts[indexPath.section-1].userURL)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 151
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 151
    }
    
    
}

