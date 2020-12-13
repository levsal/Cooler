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
    
    var profileVC : ProfileViewController?
    var feedVC : FeedViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.layer.cornerRadius = ratingView.layer.frame.height/2
        ratingView.layer.borderWidth = 2
        ratingView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
