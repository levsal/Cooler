//
//  AddFriendsTableViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/20/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class AddFriendsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: "AddFriendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddFriendsCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
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
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddFriendsCollectionViewCell", for: indexPath) as! AddFriendsCollectionViewCell
            cell.userEmail.text = "Username"
//            print("Googoogaga")
            return cell
//        }
        
    }
    
}
