//
//  K.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/9/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import Foundation
import UIKit

struct K {
    static let categoryIcons = ["Album": UIImage(systemName: "music.note"),
                         "Movie": UIImage(systemName: "film"),
                         "TV Show": UIImage(systemName: "tv"),
                         "Book": UIImage(systemName: "book"),
                         "Artist": UIImage(systemName: "person"),
                         "Song" : UIImage(systemName: "music.quarternote.3"),
                         "N/A": UIImage(systemName: "scribble")]
    
    static let categoryColorsSingular = ["Album": #colorLiteral(red: 0.5019607843, green: 0.6078431373, blue: 0.9921568627, alpha: 1),
                                  "Movie": #colorLiteral(red: 0.8745098039, green: 0.7058823529, blue: 0.1333333333, alpha: 1),
                                  "TV Show": #colorLiteral(red: 0.4823529412, green: 0.7882352941, blue: 0.431372549, alpha: 1),
                                  "Book": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
                                  "Artist": #colorLiteral(red: 0.5275336504, green: 0.8038083911, blue: 1, alpha: 1),
                                  "Song" : #colorLiteral(red: 0.7624928355, green: 0.6272898912, blue: 0.9858120084, alpha: 1),
                                  "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
}
