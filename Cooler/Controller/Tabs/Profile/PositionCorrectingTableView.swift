//
//  ProfileTableView.swift
//  Cooler
//
//  Created by Levi Saltzman on 10/9/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit


class PositionCorrectingTableView: UITableView {
    
    var offset : CGPoint = CGPoint(x: 0, y: 0)
    
    override func reloadData() {
    
        offset = contentOffset
//        print(offset)
        super.reloadData()

    }
}
