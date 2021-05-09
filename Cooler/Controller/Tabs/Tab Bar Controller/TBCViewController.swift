//
//  TBCViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/12/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class TBCViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barStyle = .default
        self.tabBar.tintColor = K.iconColor
        self.dismiss(animated: false, completion: nil)
        
    }
}


