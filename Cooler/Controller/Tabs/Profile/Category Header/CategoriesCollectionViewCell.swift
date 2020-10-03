//
//  CategoriesCollectionViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 10/2/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var category: UIButton!
    
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
}
