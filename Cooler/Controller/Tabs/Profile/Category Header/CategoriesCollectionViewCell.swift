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
    
    var firstPress = true
    
    var parentVC: ProfileViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    @IBAction func categoryPressed(_ sender: UIButton) {
        let attributedString = NSMutableAttributedString.init(string: (sender.titleLabel?.text!)!)
        
        parentVC!.resetSelectedCategories()
        
        if underlined == false {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
            underlined = true
            //Make Plural Category Header Singular
            let genre = (sender.titleLabel?.text!)!.dropLast()
            parentVC!.selectedCategories.append(String(genre))
            print(parentVC!.selectedCategories)
            parentVC?.loadPosts(from: (parentVC!.selectedCategories))
        }
        else {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 0, range: NSRange.init(location: 0, length: attributedString.length))
            underlined = false
            let exitingGenre = (sender.titleLabel?.text!)!.dropLast()
            parentVC!.selectedCategories = parentVC!.selectedCategories.filter { $0 != exitingGenre }
            print(parentVC!.selectedCategories)
            parentVC?.loadPosts(from: (parentVC!.selectedCategories))
        }
        
        sender.titleLabel!.attributedText = attributedString
    }
    
    
}
