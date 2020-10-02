//
//  FriendsPostsTableViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/30/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class FriendsPostsTableViewCell: UITableViewCell {

    @IBOutlet weak var userEmail: UIButton!
    @IBOutlet weak var friendsPostTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        friendsPostTextView.layer.borderWidth = 1
        friendsPostTextView.layer.borderColor = UIColor.red.cgColor
        friendsPostTextView.layer.cornerRadius = friendsPostTextView.layer.frame.width/40
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
