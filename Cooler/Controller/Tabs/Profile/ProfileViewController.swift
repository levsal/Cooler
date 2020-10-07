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

class ProfileViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var postTableView: UITableView!
    
    
    var categories : [String] = ["Albums", "Movies", "TV Shows", "Books"]
    var categoryColors = [#colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1), #colorLiteral(red: 0.8735565543, green: 0.705497086, blue: 0.1316877007, alpha: 1), #colorLiteral(red: 0, green: 0.7927191854, blue: 0, alpha: 1), #colorLiteral(red: 0.838627696, green: 0.3329468966, blue: 0.3190356791, alpha: 1)]
    var selectedCategories : [String] = []

    
    var isHost : Bool = true
    var resetSelecteds = true
    
    var posts: [String] = [""]
    
    let postVC: PostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postViewController") as! PostViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for category in categories {
            selectedCategories.append(String(category.dropLast()))            
        }
        print(selectedCategories)
        profilePic.layer.cornerRadius = profilePic.layer.frame.height/10
        
        addFriendButton.isHidden = true
        
        categoryCollectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        postTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        
        if isHost {
            userEmail.text = Auth.auth().currentUser?.email!
            loadPosts(from: selectedCategories)
        }
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        postTableView?.dataSource = self
        postVC.delegate = self
        
        postTableView.separatorColor = UIColor.clear
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
                        if let postText = data["text"] {
                            for genre in genres {
                                if let category = data["category"]{
                                    if category as! String == genre {
                                        self.posts.append(postText as! String)
                                    }
                                }
                            }
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


extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        
        cell.parentVC = self
        
        cell.category.setTitle(categories[indexPath.item], for: .normal)
        cell.category.setTitleColor(categoryColors[indexPath.item], for: .normal)
        
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
