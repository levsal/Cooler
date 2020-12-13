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
    static let categoryIcons = ["Album": UIImage(systemName: "music.quarternote.3"),
                         "Movie": UIImage(systemName: "film"),
                         "TV Show": UIImage(systemName: "tv"),
                         "Book": UIImage(systemName: "book"),
                         "Artist": UIImage(systemName: "person"),
                         "Song" : UIImage(systemName: "music.note"),
                         "Misc.": UIImage(systemName: "scribble")]
   
    static let categoryIconsPlural = ["Albums": UIImage(systemName: "music.quarternote.3"),
                         "Movies": UIImage(systemName: "film"),
                         "TV Shows": UIImage(systemName: "tv"),
                         "Books": UIImage(systemName: "book"),
                         "Artists": UIImage(systemName: "person"),
                         "Songs" : UIImage(systemName: "music.note"),
                         "Misc./": UIImage(systemName: "scribble")]
    
    
    static let categoryColorsSingular = ["Album": #colorLiteral(red: 0.5019607843, green: 0.6078431373, blue: 0.9921568627, alpha: 1),
                                  "Movie": #colorLiteral(red: 0.8745098039, green: 0.7058823529, blue: 0.1333333333, alpha: 1),
                                  "TV Show": #colorLiteral(red: 0.4823529412, green: 0.7882352941, blue: 0.431372549, alpha: 1),
                                  "Book": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
                                  "Artist": #colorLiteral(red: 0.6062647104, green: 0.7891756296, blue: 1, alpha: 1),
                                  "Song" : #colorLiteral(red: 0.7462700009, green: 0.6362549067, blue: 0.98562783, alpha: 1),
                                  "Misc": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    
    static let categoryColorsPlural = ["Albums": #colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1),
                                "Movies": #colorLiteral(red: 0.8745098039, green: 0.7058823529, blue: 0.1333333333, alpha: 1),
                                "TV Shows": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1),
                                "Books": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
                                "Artists": #colorLiteral(red: 0.6062647104, green: 0.7891756296, blue: 1, alpha: 1),
                                "Songs" : #colorLiteral(red: 0.7462700009, green: 0.6362549067, blue: 0.98562783, alpha: 1),
                                "Misc./": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
}
