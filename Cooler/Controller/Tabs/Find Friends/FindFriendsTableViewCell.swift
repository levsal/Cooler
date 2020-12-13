//
//  FindFriendsTableViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 10/24/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class FindFriendsTableViewCell: UITableViewCell {

    var parentFindFriendsVC : FindFriendsViewController?
    var parentMessagesVC : MessagesViewController?
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func segueTriggerPressed(_ sender: Any) {
        if parentFindFriendsVC != nil {
            for friend in parentFindFriendsVC!.friends {
                if friend.name == name.text {
                    parentFindFriendsVC?.segueEmail = friend.email!
                    parentFindFriendsVC?.segueName = friend.name!
                }
            }
            parentFindFriendsVC?.performSegue(withIdentifier: "SearchToProfile", sender: self)
        }
        else {
            for friend in parentMessagesVC!.friends {
                if friend.name == name.text {
                    parentMessagesVC?.segueURL = friend.picURL!
                    parentMessagesVC?.segueName = friend.name!
                }
            }

            parentMessagesVC?.performSegue(withIdentifier: "MessagesToConvo", sender: self)
        }
       
    }
    
    
    
    
   
   
    
}
