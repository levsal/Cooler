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
    var listedOpen : [Double: Bool] = [:]
    
    @IBOutlet var listTableView: PositionCorrectingTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        listTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        listTableView.register(UINib(nibName: "PostDetailView", bundle: nil), forCellReuseIdentifier: "PostDetailView")
        
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
                          
                            self.listeds.append(Post(date: date as? Double, dateString: dateString as? String, postText: postText as? String, category: category as? String, creator: creator as? String, blurb: blurb as? String, rating: givenRating as? Double, fromUser: user as? String))

                        }
                        
                        DispatchQueue.main.async {
                            for listed in self.listeds {
                                self.listedOpen[listed.date!] = false
                            }
                            self.listTableView?.reloadData()
                        }
                    }
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
        
        cell.date = listeds[section].date
        if listedOpen[listeds[section].date!] ?? false {
            cell.openClosedArrow.image = UIImage(systemName: "chevron.down")
        }
        
        
        cell.categoryIcon.image = K.categoryIcons[listeds[section].category!] as? UIImage
        cell.categoryIcon.tintColor = K.categoryColorsSingular[listeds[section].category!]
        cell.category = listeds[section].category
        cell.blurb = listeds[section].blurb
        cell.rating = listeds[section].rating

        cell.friendsPostTextView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.friendsPostTextView.layer.cornerRadius = cell.friendsPostTextView.frame.height/4.5
        
        cell.creatorTextView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cell.creatorTextView.layer.cornerRadius = cell.friendsPostTextView.frame.height/4.5
        
        cell.listButton.isHidden = false
        cell.repostButton.isHidden = false

        cell.listButton.setImage(UIImage(systemName: "xmark"), for: .normal) 
        return cell
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let listed = listeds[section]
        if listedOpen[listed.date!] == false {
            return 0
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailView") as! PostDetailView
        cell.ratingValue.text = "\(listeds[indexPath.section].rating!)"
        
        var aOrAn = " a "
        if listeds[indexPath.section].rating! > 7.9 && listeds[indexPath.section].rating! < 9.0 {
            aOrAn = " an "
        }
        
        var category = listeds[indexPath.section].category
        if category != "TV Show" {
            category = category?.lowercased()
        }
        else {
            category = "TV show"
        }
        
        cell.blurbTextView.text =
            "" +
            listeds[indexPath.section].fromUser! +
            " gave this " +
            category! +
            aOrAn +
            "\(listeds[indexPath.section].rating!)" +
            " and said, " +
            "\"\(listeds[indexPath.section].blurb!)\""
        
        return cell
       
    }
    


}
