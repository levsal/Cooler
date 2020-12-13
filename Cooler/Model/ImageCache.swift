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
