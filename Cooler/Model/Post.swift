//
//  Post.swift
//  Cooler
//
//  Created by Levi Saltzman on 10/1/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import Foundation
import UIKit

struct Post: Equatable {
    var user: String?
    var date : Double
    var postText : String
    var category: String
    var creator: String
    var blurb: String
    var rating: Double
}
