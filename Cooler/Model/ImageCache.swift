//
//  ImageCache.swift
//  Cooler
//
//  Created by Levi Saltzman on 10/26/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import Foundation
import UIKit

extension UIImage: NSDiscardableContent{
    
    public func beginContentAccess() -> Bool {
        return true
    }
    
    public func endContentAccess() {
        
    }
    
    public func discardContentIfPossible() {
        
    }
    
    public func isContentDiscarded() -> Bool {
        return false
    }
}

//extension UIImage {
//    enum JPEGQuality: CGFloat {
//        case lowest  = 0
//        case low     = 0.25
//        case medium  = 0.5
//        case high    = 0.75
//        case highest = 1
//    }
//
//    func jpeg(_ quality: JPEGQuality) -> Data? {
//        return self.jpegData(compressionQuality: quality.rawValue)
//    }
//}
