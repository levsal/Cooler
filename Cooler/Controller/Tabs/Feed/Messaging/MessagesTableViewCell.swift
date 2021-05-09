//
//  MessagesTableViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/12/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageText: UILabel!
    @IBOutlet var messageLeading: NSLayoutConstraint!
    @IBOutlet var messageTrailing: NSLayoutConstraint!
    @IBOutlet var messageWidth: NSLayoutConstraint!
    
    var parentConvoVC : ConvoViewController?
//    @IBOutlet var messageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = K.backgroundColor
        messageView.backgroundColor = K.tileColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func triggerPressed(_ sender: Any) {
        parentConvoVC?.dismissKeyboard()
    }

}
