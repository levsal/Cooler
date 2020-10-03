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
    func appendToArray(post: String)
}

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet var userEmail: UILabel!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var postTableView: UITableView!
    
    var isHost : Bool = true
    var posts: [String] = [""]
    
    let postVC: PostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postViewController") as! PostViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.layer.frame.height/10
        
        addFriendButton.isHidden = true
        
        categoryCollectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        postTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        
        if isHost {
            userEmail?.text = Auth.auth().currentUser?.email!
            
            loadPosts()
            
            
        }
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        postTableView?.dataSource = self
        postVC.delegate = self
        
        postTableView.separatorColor = UIColor.clear
        
    }
    
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        present(postVC, animated: true)
    }
    
    func loadPosts(){
        //        print(userEmail.text!)
        db.collection("\(userEmail.text!)_Posts").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.posts = []
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let postText = data["text"] {
                            self.posts.append(postText as! String)
                        }
                        DispatchQueue.main.async {
                            self.postTableView?.reloadData()
                        }
                    }
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
extension ProfileViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(UIScreen.main.bounds.width)
        return CGSize(width: CGFloat((collectionView.frame.size.width / 3)), height: CGFloat(20))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        return cell
    }
    
    
}

//MARK: - Table View
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsPostsTableViewCell", for: indexPath) as! FriendsPostsTableViewCell
        cell.friendsPostTextView.text = posts[indexPath.row]
        if isHost{
            cell.userEmail.isHidden = true
        }
        return cell
    }
    
    
}

extension ProfileViewController: PopoverDelegate {
    func appendToArray(post: String) {
        posts.append(post)
    }
    
    
}
