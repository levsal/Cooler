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
    
    static var currentUserName = ""
    static var currentUserPicURL = ""
    
    
    static let categoryIcons = ["Album": UIImage(systemName: "music.quarternote.3"),
                         "Movie": UIImage(systemName: "film.fill"),
                         "TV Show": UIImage(systemName: "tv.fill"),
                         "Book": UIImage(systemName: "book.fill"),
                         "Artist": UIImage(systemName: "person.fill"),
                         "Song" : UIImage(systemName: "music.note"),
                         "Misc": UIImage(systemName: "scribble")]
   
    static let categoryIconsPlural = ["Albums": UIImage(systemName: "music.quarternote.3"),
                         "Movies": UIImage(systemName: "film.fill"),
                         "TV Shows": UIImage(systemName: "tv.fill"),
                         "Books": UIImage(systemName: "book.fill"),
                         "Artists": UIImage(systemName: "person.fill"),
                         "Songs" : UIImage(systemName: "music.note"),
                         "Misc.": UIImage(systemName: "scribble")]
    
    
    static let categoryColorsSingular = ["Album": #colorLiteral(red: 0.5411764706, green: 0.6470588235, blue: 0.9882352941, alpha: 1),
                                  "Movie": #colorLiteral(red: 0.8695387244, green: 0.7354239225, blue: 0.2352400422, alpha: 1),
                                  "TV Show": #colorLiteral(red: 0.5338507295, green: 0.7872315049, blue: 0.5110785961, alpha: 1),
                                  "Book": #colorLiteral(red: 0.885936439, green: 0.6727313399, blue: 0.7194210887, alpha: 1),
                                  "Artist": #colorLiteral(red: 0.659673512, green: 0.8416125178, blue: 0.9962553382, alpha: 1),
                                  "Song" : #colorLiteral(red: 0.7758142352, green: 0.7204052806, blue: 0.98112005, alpha: 1),
                                  "Misc": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    
    static let categoryColorsPlural = ["Albums": #colorLiteral(red: 0.5411764706, green: 0.6470588235, blue: 0.9882352941, alpha: 1),
                                "Movies": #colorLiteral(red: 0.8705882353, green: 0.737254902, blue: 0.2352941176, alpha: 1),
                                "TV Shows": #colorLiteral(red: 0.5338507295, green: 0.7872315049, blue: 0.5110785961, alpha: 1),
                                "Books": #colorLiteral(red: 0.885936439, green: 0.6727313399, blue: 0.7194210887, alpha: 1),
                                "Artists": #colorLiteral(red: 0.659673512, green: 0.8416125178, blue: 0.9962553382, alpha: 1),
                                "Songs" : #colorLiteral(red: 0.7758142352, green: 0.7204052806, blue: 0.98112005, alpha: 1),
                                "Misc.": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    
}
