//
//  PostDetailView.swift
//  Cooler
//
//  Created by Levi Saltzman on 10/9/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class PostDetailView: UITableViewCell {
    @IBOutlet weak var blurbTextView: UITextView!
    @IBOutlet weak var ratingValue: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var ratingView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet var actionBar: UIView!
    @IBOutlet var repostStack: UIStackView!
    @IBOutlet var separator: UILabel!
    @IBOutlet var category: UIButton!
    @IBOutlet var repostDetail: UIButton!
    
    var fromUserEmail : String?
    var userURL : String?
    
    var packagedPost : Post?
    
    var parentFriendsPostsTableVC : FriendsPostsTableViewCell?
    var profileVC : ProfileViewController?
    var feedVC : FeedViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.layer.cornerRadius = ratingView.layer.frame.height/2
        
        ratingValue.textColor = K.fontColor
        ratingView.backgroundColor = K.tileColor
        contentView.backgroundColor = K.backgroundColor
        blurbTextView.textColor = K.fontColor
        
        category.tintColor = K.fontColor
        repostDetail.tintColor = K.fontColor
        separator.tintColor = K.fontColor
        
        repostStack.isHidden = true
        separator.isHidden = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func DMpressed(_ sender: Any) {
        print(packagedPost)
        feedVC?.sendingMessage = true
        feedVC?.postToSend = packagedPost
        feedVC?.performSegue(withIdentifier: "FeedToMessages", sender: self)
    }
    @IBAction func repostDetailPressed(_ sender: Any) {
        let profileVC: ProfileViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
   
        profileVC.picFromCell = true
        self.profileVC?.present(profileVC, animated: true)
        self.feedVC?.present(profileVC, animated: true)
        profileVC.isHost = false
        profileVC.profilePic.loadAndCacheImage(urlString: userURL!)

        profileVC.email = fromUserEmail!
        profileVC.loadProfilePage(email: fromUserEmail!)

        
    }
}
