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
    @IBOutlet weak var ratingCircle: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        stackView.layer.borderWidth = 2
//        stackView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
