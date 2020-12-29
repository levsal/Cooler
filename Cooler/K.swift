//
//  K.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/9/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct K {
    static let categoryIcons = ["Album": UIImage(systemName: "music.quarternote.3"),
                         "Movie": UIImage(systemName: "film"),
                         "TV Show": UIImage(systemName: "tv"),
                         "Book": UIImage(systemName: "book"),
                         "Artist": UIImage(systemName: "person"),
                         "Song" : UIImage(systemName: "music.note"),
                         "Misc": UIImage(systemName: "scribble")]
   
    static let categoryIconsPlural = ["Albums": UIImage(systemName: "music.quarternote.3"),
                         "Movies": UIImage(systemName: "film"),
                         "TV Shows": UIImage(systemName: "tv"),
                         "Books": UIImage(systemName: "book"),
                         "Artists": UIImage(systemName: "person"),
                         "Songs" : UIImage(systemName: "music.note"),
                         "Misc.": UIImage(systemName: "scribble")]
    
    
    static let categoryColorsSingular = ["Album": #colorLiteral(red: 0.5395770073, green: 0.6487958431, blue: 0.9900574088, alpha: 1),
                                  "Movie": #colorLiteral(red: 0.8695387244, green: 0.7354239225, blue: 0.2352400422, alpha: 1),
                                  "TV Show": #colorLiteral(red: 0.4823529412, green: 0.7882352941, blue: 0.431372549, alpha: 1),
                                  "Book": #colorLiteral(red: 0.8985158801, green: 0.582652092, blue: 0.6694814563, alpha: 1),
                                  "Artist": #colorLiteral(red: 0.6062647104, green: 0.7891756296, blue: 1, alpha: 1),
                                  "Song" : #colorLiteral(red: 0.7462700009, green: 0.6362549067, blue: 0.98562783, alpha: 1),
                                  "Misc": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    
    static let categoryColorsPlural = ["Albums": #colorLiteral(red: 0.5395770073, green: 0.6487958431, blue: 0.9900574088, alpha: 1),
                                "Movies": #colorLiteral(red: 0.8695387244, green: 0.7354239225, blue: 0.2352400422, alpha: 1),
                                "TV Shows": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1),
                                "Books": #colorLiteral(red: 0.8985158801, green: 0.582652092, blue: 0.6694814563, alpha: 1),
                                "Artists": #colorLiteral(red: 0.6062647104, green: 0.7891756296, blue: 1, alpha: 1),
                                "Songs" : #colorLiteral(red: 0.7462700009, green: 0.6362549067, blue: 0.98562783, alpha: 1),
                                "Misc.": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    
}
