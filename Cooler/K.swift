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
    
    static var friends : [Friend] = []
    
    static let categoryNames = ["Albums", "Movies", "TV Shows", "Books", "Artists", "Songs", "Podcasts"]
//               , "Misc."]

    static let categoryIcons = ["Album": UIImage(systemName: "music.quarternote.3"),
                         "Movie": UIImage(systemName: "film.fill"),
                         "TV Show": UIImage(systemName: "tv.fill"),
                         "Book": UIImage(systemName: "book.fill"),
                         "Artist": UIImage(systemName: "person.fill"),
                         "Song" : UIImage(systemName: "music.note"),
                         "Podcast" : UIImage(systemName: "mic.fill")]
//        ,
//                         "Misc": UIImage(systemName: "scribble"),]
   
    static let categoryIconsPlural = ["Albums": UIImage(systemName: "music.quarternote.3"),
                         "Movies": UIImage(systemName: "film.fill"),
                         "TV Shows": UIImage(systemName: "tv.fill"),
                         "Books": UIImage(systemName: "book.fill"),
                         "Artists": UIImage(systemName: "person.fill"),
                         "Songs" : UIImage(systemName: "music.note"),
                         "Podcasts" : UIImage(systemName: "mic.fill")]
//        ,
//                         "Misc.": UIImage(systemName: "scribble")]
    
    //Original Colors
//    static let categoryColorsSingular = ["Album": #colorLiteral(red: 0.5411764706, green: 0.6470588235, blue: 0.9882352941, alpha: 1),
//                                  "Movie": #colorLiteral(red: 0.8549019608, green: 0.8039215686, blue: 0.3333333333, alpha: 1),
//                                  "TV Show": #colorLiteral(red: 0.5338507295, green: 0.7872315049, blue: 0.5110785961, alpha: 1),
//                                  "Book": #colorLiteral(red: 0.885936439, green: 0.6727313399, blue: 0.7194210887, alpha: 1),
//                                  "Artist": #colorLiteral(red: 0.5799238682, green: 0.8220599294, blue: 0.9982820153, alpha: 1),
//                                  "Song" : #colorLiteral(red: 0.7758142352, green: 0.7204052806, blue: 0.98112005, alpha: 1),
//                                  "Podcast" : #colorLiteral(red: 0.9861215949, green: 0.5122104287, blue: 0.4508516192, alpha: 1)]
//
//    static let categoryColorsPlural = ["Albums": #colorLiteral(red: 0.5411764706, green: 0.6470588235, blue: 0.9882352941, alpha: 1),
//                                "Movies": #colorLiteral(red: 0.8565239906, green: 0.805349052, blue: 0.3322198987, alpha: 1),
//                                "TV Shows": #colorLiteral(red: 0.5333333333, green: 0.7882352941, blue: 0.5098039216, alpha: 1),
//                                "Books": #colorLiteral(red: 0.8862745098, green: 0.6745098039, blue: 0.7176470588, alpha: 1),
//                                "Artists": #colorLiteral(red: 0.5799238682, green: 0.8220599294, blue: 0.9982820153, alpha: 1),
//                                "Songs" : #colorLiteral(red: 0.7758142352, green: 0.7204052806, blue: 0.98112005, alpha: 1),
//                                "Podcasts" : #colorLiteral(red: 0.9861215949, green: 0.5122104287, blue: 0.4508516192, alpha: 1)]
    
    static let categoryColorsSingular = ["Album": #colorLiteral(red: 0.6588235294, green: 0.7176470588, blue: 1, alpha: 1),
                                  "Movie": #colorLiteral(red: 0.9137254902, green: 0.8431372549, blue: 0.3450980392, alpha: 1),
                                  "TV Show": #colorLiteral(red: 0.4549019608, green: 0.8588235294, blue: 0.5960784314, alpha: 1),
                                  "Book": #colorLiteral(red: 0.9882352941, green: 0.6901960784, blue: 0.7019607843, alpha: 1),
                                  "Artist": #colorLiteral(red: 0.6509803922, green: 0.8666666667, blue: 1, alpha: 1),
                                  "Song" : #colorLiteral(red: 0.8196078431, green: 0.768627451, blue: 1, alpha: 1),
                                  "Podcast" : #colorLiteral(red: 0.9843137255, green: 0.5137254902, blue: 0.4509803922, alpha: 1)]
    static let categoryColorsPlural = ["Albums": #colorLiteral(red: 0.6588235294, green: 0.7176470588, blue: 1, alpha: 1),
                                  "Movies": #colorLiteral(red: 0.9137254902, green: 0.8431372549, blue: 0.3450980392, alpha: 1),
                                  "TV Shows": #colorLiteral(red: 0.4549019608, green: 0.8588235294, blue: 0.5960784314, alpha: 1),
                                  "Books": #colorLiteral(red: 0.9882352941, green: 0.6901960784, blue: 0.7019607843, alpha: 1),
                                  "Artists": #colorLiteral(red: 0.6509803922, green: 0.8666666667, blue: 1, alpha: 1),
                                  "Songs" : #colorLiteral(red: 0.8196078431, green: 0.768627451, blue: 1, alpha: 1),
                                  "Podcasts" : #colorLiteral(red: 0.9843137255, green: 0.5137254902, blue: 0.4509803922, alpha: 1)]
}
