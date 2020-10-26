//
//  UIImageCacher.swift
//  Cooler
//
//  Created by Levi Saltzman on 10/22/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import FirebaseStorage
import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView : NSDiscardableContent{
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
    
    
    func loadAndCacheImage(urlString: String){
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        print("Fetching image for first time")
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    print(error!)
                }
                else {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data!){
                            imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                            self.image = downloadedImage
                        }
                    }
                }
                
            }.resume()
        }
    }
    
}
