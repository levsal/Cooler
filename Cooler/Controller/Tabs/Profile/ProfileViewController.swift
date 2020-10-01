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
    
    @IBOutlet var userEmail: UILabel!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBOutlet weak var postTableView: UITableView!
    
    var isHost : Bool = true
    var posts: [String] = [""]
    
    let postVC: PostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postViewController") as! PostViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFriendButton.isHidden = true
        
        if isHost {
            userEmail?.text = Auth.auth().currentUser?.email!
            loadPosts()
            
        }
        postTableView?.dataSource = self
        postVC.delegate = self
        
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
    }
}


extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row] ?? "Goog"
        return cell
    }
    
    
}

extension ProfileViewController: PopoverDelegate {
    func appendToArray(post: String) {
        posts.append(post)
    }
    
    
}
