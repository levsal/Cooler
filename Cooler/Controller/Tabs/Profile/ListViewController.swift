//
//  ListViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/7/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    
    var parentProfileVC : ProfileViewController?
    
    var listeds : [Post] = []
    
    @IBOutlet var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()


        listTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        
        listTableView.dataSource = self
        listTableView.delegate = self
        
        loadPosts()
    }
    
    func loadPosts(){
        
        db.collection("Users").document(parentProfileVC!.email).collection("List").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.listeds = []
            //            print(self.posts)
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let postText = data["text"],
                           let date = data["date"],
                           let dateString = data["dateString"],
                           let creator = data["creator"],
                           let blurb = data["blurb"],
                           let givenRating = data["rating"],
                           let category = data["category"],
                           let user = data["user"]
                           {
                            
                          
                            self.listeds.append(Post(date: date as! Double, dateString: dateString as! String, postText: postText as! String, category: category as! String, creator: creator as! String, blurb: blurb as! String, rating: givenRating as! Double, fromUser: user as? String))

                        }
                        
                        DispatchQueue.main.async {
                            
                            self.listTableView?.reloadData()
                        }
                    }
//                    self.assignValuesToPostOpen()
//
//                    self.postsCountValue = "Posts: " + String(self.posts.count)
//                    if let pCount = self.postsCount {
//                        pCount.setTitle(self.postsCountValue, for: .normal)
//                    }
                    
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listeds.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = Bundle.main.loadNibNamed("FriendsPostsTableViewCell", owner: self, options: nil)?.first as! FriendsPostsTableViewCell
        cell.parentListVC = self
        cell.friendsPostTextView.text = listeds[section].postText
        cell.creatorTextView.text = listeds[section].creator
        
        cell.categoryIcon.image = K.categoryIcons[listeds[section].category!] as? UIImage
        cell.categoryIcon.tintColor = K.categoryColorsSingular[listeds[section].category!]

        return cell
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailView") as! PostDetailView
        
        return cell
       
    }
    


}
