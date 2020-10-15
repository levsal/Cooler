//
//  AddFriendsTableViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/20/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore



class AddFriendsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let db = Firestore.firestore()
    
    var users : [[String]]? = [["", ""]]
    
    var parentVC: UIViewController?
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: "AddFriendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddFriendsCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
        fetchUsers()
    }
    
    func fetchUsers() {
        db.collection("Users").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.users = []
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let userEmail = data["email"], let username = data["name"] {
                            self.users?.append([userEmail as! String, username as! String])
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}

extension AddFriendsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddFriendsCollectionViewCell", for: indexPath) as! AddFriendsCollectionViewCell
        cell.email = (users?[indexPath.row][0])!
//        cell.name = (users?[indexPath.row][1])!
        cell.userEmail.setTitle(users?[indexPath.row][1], for: .normal)
        cell.parentCell = self
        return cell
    }
    
}
