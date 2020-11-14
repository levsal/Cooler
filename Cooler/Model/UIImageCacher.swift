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

let imageCache = NSCache <NSString, UIImage>()

extension UIImageView {
    
    func loadAndCacheImage(urlString: String){
        
//        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            
            self.image = cachedImage
            return
        }
        
        
        else if let url = URL(string: urlString) {

            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    print(error!)
                }
                else {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data!){
                            self.image = downloadedImage
                            imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                        }
                    }
                }
                
            }.resume()
        }
    }
    
}
