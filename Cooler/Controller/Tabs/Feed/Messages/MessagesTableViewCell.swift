//
//  MessagesTableViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/12/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    @IBOutlet var messageText: UILabel!
    @IBOutlet var messageLeading: NSLayoutConstraint!
    @IBOutlet var messageTrailing: NSLayoutConstraint!
    @IBOutlet var messageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
