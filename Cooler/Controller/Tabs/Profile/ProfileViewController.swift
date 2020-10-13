//
//  ProfileViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/8/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase

protocol PopoverDelegate {
    func appendToArray(post: Post)
}

class ProfileViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBOutlet weak var friendsCount: UIButton!
    @IBOutlet weak var postsCount: UIButton!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var postTableView: PositionCorrectingTableView!
    
    
    var categories : [String] = ["Albums", "Movies", "TV Shows", "Books"]
    
    var selectedCategories : [String] = []
        
    var categoryColorsSingular = ["Album": #colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1), "Movie": #colorLiteral(red: 0.8735565543, green: 0.705497086, blue: 0.1316877007, alpha: 1), "TV Show": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1), "Book": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    var categoryColorsSingularPale = ["Album": #colorLiteral(red: 0.7195122838, green: 0.7771759033, blue: 0.9829060435, alpha: 1), "Movie": #colorLiteral(red: 0.8376982212, green: 0.8472841382, blue: 0.4527434111, alpha: 1), "TV Show": #colorLiteral(red: 0.6429418921, green: 0.8634710908, blue: 0.6248642206, alpha: 1), "Book": #colorLiteral(red: 0.886295557, green: 0.6721803546, blue: 0.6509570479, alpha: 1), "N/A": #colorLiteral(red: 0.3980969191, green: 0.4254524708, blue: 0.4201924801, alpha: 1)]
    var categoryColorsPlural = ["Albums": #colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1), "Movies": #colorLiteral(red: 0.8735565543, green: 0.705497086, blue: 0.1316877007, alpha: 1), "TV Shows": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1), "Books": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    var categoryIcons = ["Album": UIImage(systemName: "music.note"), "Movie": UIImage(systemName: "film"), "TV Show": UIImage(systemName: "tv"), "Book": UIImage(systemName: "book"), "N/A": UIImage(systemName: "scribble")]
    
    var postOpen : [String: Bool] = [:]
    
    var isHost : Bool = true
    var resetSelecteds = true
    
    var posts: [Post] = []
    var friends : [String] = []
    
    let postVC: PostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postViewController") as! PostViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for category in categories {
            selectedCategories.append(String(category.dropLast()))
        }
        //        print(selectedCategories)
        profilePic.layer.cornerRadius = profilePic.layer.frame.height/10
        
        addFriendButton.isHidden = true
        
        categoryCollectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        postTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        postTableView.register(UINib(nibName: "PostDetailView", bundle: nil), forCellReuseIdentifier: "PostDetailView")
        
        if isHost {
            userEmail.text = Auth.auth().currentUser?.email!
            loadPosts(from: selectedCategories)
            getFriends(of: (Auth.auth().currentUser?.email!)!)
        }
        
        
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        postTableView?.dataSource = self
        postTableView.delegate = self
        
        postVC.delegate = self
        
        postTableView.separatorColor = UIColor.clear
        
        
    }

    func assignValuesToPostOpen() {
        for post in posts {
            postOpen[post.postText] = false
        }
        //        print(postOpen)
    }
    
    //Called from Category Cells
    func resetSelectedCategories() {
        if resetSelecteds {
            selectedCategories = []
            resetSelecteds = false
        }
    }
    
    
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        present(postVC, animated: true)
    }
    
    func loadPosts(from genres: [String]){
        db.collection("\(userEmail.text!)_Posts").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.posts = []
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let postText = data["text"], let date = data["date"], let creator = data["creator"] {
                            //Filter by selected genre
                            for genre in genres {
                                if let category = data["category"]{
                                    if category as! String == genre {
                                        self.posts.append(Post(user: nil, date: date as! Double, postText: postText as! String, category: category as! String, creator: creator as! String))
                                        
//                                    print(self.posts)
                                    }
                                }
                            }
                            
                        }
                        DispatchQueue.main.async {
                            self.postTableView?.reloadData()
                        }
                    }
                    self.assignValuesToPostOpen()
                    self.postsCount.setTitle("Posts: \(self.posts.count)", for: .normal)
                }
            }
        }
        
        
        
    }
    
    func getFriends(of email : String) {
        
        db.collection("\(email)_Friends").order(by: "date").addSnapshotListener { (querySnapshot, error) in
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
                    self.friendsCount.setTitle("Friends: \(self.friends.count)", for: .normal)
                }
            }
        }
        
        
    }
    
    @IBAction func addFriendPressed(_ sender: UIButton) {
        print("Current user is \(Auth.auth().currentUser!.email!)")
        print("Adding friend \(userEmail.text!)")
        
        db.collection("\(Auth.auth().currentUser!.email!)_Friends").addDocument(data: ["date" : Date().timeIntervalSince1970, "email": userEmail.text!])
        self.dismiss(animated: true) {
            
        }
    }
}

//MARK: - Collection View


extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        
        cell.parentVC = self
        
        cell.category.setTitle(categories[indexPath.item], for: .normal)
        cell.category.setTitleColor(categoryColorsPlural[cell.category.titleLabel!.text!], for: .normal)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.frame.size.width / CGFloat(categories.count))), height: CGFloat(20))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - Table View
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section <= posts.count - 1 {
            
            let cell = Bundle.main.loadNibNamed("FriendsPostsTableViewCell", owner: self, options: nil)?.first as! FriendsPostsTableViewCell
            
            cell.parentProfileVC = self
            
            cell.friendsPostTextView.text = posts[section].postText
            cell.creatorTextView.text = posts[section].creator
            
            cell.friendsPostTextView.backgroundColor = categoryColorsSingular[posts[section].category]
            cell.creatorTextView.backgroundColor = categoryColorsSingularPale[posts[section].category]
            
            cell.categoryIcon.image = categoryIcons[posts[section].category]!!
            
            cell.userEmail.isHidden = true
            cell.userEmail.heightAnchor.constraint(equalToConstant: 0).isActive = true
            
            return cell
        }
        else {
            return UIView()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count + 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return posts[section].postText
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= posts.count - 1 {
            let post = posts[section]
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailView", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

extension ProfileViewController: PopoverDelegate {
    func appendToArray(post: Post) {
        posts.append(post)
    }
}

