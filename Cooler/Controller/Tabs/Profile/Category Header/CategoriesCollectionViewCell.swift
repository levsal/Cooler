//
//  CategoriesCollectionViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 10/2/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var category: UIButton!
    
    var underlined = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        category.titleLabel?.text = String()
    }
    
    @IBAction func categoryPressed(_ sender: UIButton) {
        let attributedString = NSMutableAttributedString.init(string: (sender.titleLabel?.text!)!)
        
        if underlined == false {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
            underlined = true
        }
        else {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 0, range: NSRange.init(location: 0, length: attributedString.length))
            underlined = false
        }
        
        sender.titleLabel!.attributedText = attributedString
    }
    
    
}
