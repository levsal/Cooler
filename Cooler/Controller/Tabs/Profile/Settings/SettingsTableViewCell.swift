//
//  SettingsTableViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/1/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    var parentSettingsVC : UserSettingsViewController?
    @IBOutlet var headerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func headerPressed(_ sender: UIButton) {
        
    }
    
    
    
    
}
