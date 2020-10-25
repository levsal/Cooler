//
//  CategoriesCollectionViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 10/2/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var category: UILabel!
    
    var underlined = false
        
    var parentVC: ProfileViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}



