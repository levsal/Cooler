//
//  AddFriendsTableViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/20/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore



class AddFriendsTableViewCell: UITableViewCell{
    
    let db = Firestore.firestore()
    
    @IBOutlet var addFriendsLabel: UILabel!
    
    var potentialFriends : [Friend] = []
    
    var firstCollectionViewLoad = true
    
    var parentFeedVC: FeedViewController?
    
    @IBOutlet weak var emptyCollectionViewLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: "AddFriendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddFriendsCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        addFriendsLabel.textColor = K.fontColor
        contentView.backgroundColor = K.backgroundColor
        emptyCollectionViewLabel.backgroundColor = K.backgroundColor
        collectionView.backgroundColor = K.backgroundColor
    }

    
    func fetchUsers() {
        if let parentFriends = parentFeedVC?.friends {
            
            //PRINT FRIEND NAMES

//            if let blankIndex = self.potentialFriends?.firstIndex(of: ["","",""]){
//                self.potentialFriends?.remove(at: blankIndex)
//            }

            
            for friend in parentFriends {
//                print(friend[1] + "'s run")
                
//                print(friend[0])
                db.collection("Users").document(friend.email!).collection("Friends").addSnapshotListener { [self] (querySnapshot, error) in
                    if let e = error {
                        print("There was an issue retrieving potential friends from Firestore, \(e)")
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                
                                let data = doc.data()
                                
                                if let userEmail = data["email"],
                                   let username = data["name"],
                                   let picURL = data["picURL"]{
                                    
                                    
//                                    print(parentFriends)
//                                    print([userEmail as! String, username as! String, picURL as! String])
                                    
                                    var alreadyFriend = false
                                    for friend in parentFriends{
                                        let name = friend.name
                                        if name == username as? String {
                                            alreadyFriend = true
                                        }
                                    }
                                    
                                    var alreadyPotential = false
                                    for friend in self.potentialFriends{
                                        let name = friend.name
                                        if name == username as! String {
                                            alreadyPotential = true
                                        }
                                    }
                                    
                                    var currentUser = false
                                    if userEmail as! String == self.parentFeedVC!.currentUser {
                                        currentUser = true
                                    }
                                    
                                    
                                    if alreadyFriend || alreadyPotential || currentUser {
                                        
//                                        print("\(username as! String) already potentialized")
                                    }
                                    
                                    else {
                                        self.potentialFriends.append(Friend(email: userEmail as? String,
                                                                            name: username as? String,
                                                                            date: nil,
                                                                            picURL: picURL as? String,
                                                                            bio: nil,
                                                                            lastMessageTimeString: nil))
                                        self.collectionView.reloadData()
                                    }
                                }
                            }
                            
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

extension AddFriendsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if potentialFriends == [] {
            emptyCollectionViewLabel.isHidden = false
            collectionView.isHidden = true
        }
        else {
//            print(potentialFriends)
            emptyCollectionViewLabel.isHidden = true
            collectionView.isHidden = false
        }
        return potentialFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddFriendsCollectionViewCell", for: indexPath) as! AddFriendsCollectionViewCell
        
        cell.parentCell = self
        //        cell.profilePic.contentMode = .scaleAspectFit
        
//        print("Row: \(indexPath.row) \(potentialFriends![indexPath.row][0]) \(potentialFriends![indexPath.row][1]) \(potentialFriends![indexPath.row][2])")
        cell.email = potentialFriends[indexPath.row].email!
        cell.userEmail.text = potentialFriends[indexPath.row].name!
        cell.picURL = potentialFriends[indexPath.row].picURL!

        //Get Profile Pic
        DispatchQueue.main.async {
            cell.profilePic.loadAndCacheImage(urlString: self.potentialFriends[indexPath.row].picURL!)
        }
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let addFriendsCell = collectionView.cellForItem(at: indexPath)! as! AddFriendsCollectionViewCell
        
        addFriendsCell.setUpProfile()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
