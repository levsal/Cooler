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
    
    static var currentUserEmail = ""
    static var currentUserName = ""
    static var currentUserPicURL = ""
    
    static var friends : [Friend] = []
    
    static let categoryNames = ["Albums", "Movies", "TV Shows", "Books", "Artists", "Songs", "Podcasts"]

    static let categoryIcons = ["Album": UIImage(systemName: "music.quarternote.3"),
                         "Movie": UIImage(systemName: "film.fill"),
                         "TV Show": UIImage(systemName: "tv.fill"),
                         "Book": UIImage(systemName: "book.fill"),
                         "Artist": UIImage(systemName: "person.fill"),
                         "Song" : UIImage(systemName: "music.note"),
                         "Podcast" : UIImage(systemName: "mic.fill")]
   
    static let categoryIconsPlural = ["Albums": UIImage(systemName: "music.quarternote.3"),
                         "Movies": UIImage(systemName: "film.fill"),
                         "TV Shows": UIImage(systemName: "tv.fill"),
                         "Books": UIImage(systemName: "book.fill"),
                         "Artists": UIImage(systemName: "person.fill"),
                         "Songs" : UIImage(systemName: "music.note"),
                         "Podcasts" : UIImage(systemName: "mic.fill")]
    
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

    static let subheadingDictionary = ["Albums": "Artist/Band",
                                      "Movies": "Genre",
                                      "TV Shows": "Genre",
                                      "Books": "Author(s)",
                                      "Artists": "Category",
                                      "Songs" : "Artist/Band",
                                      "Podcasts" : "Host(s)"]
    
////
//        static let navigationBarColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        static let tileColor = #colorLiteral(red: 0.1138141975, green: 0.1143484786, blue: 0.1156276539, alpha: 1)
//
//        static let backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
//        static var fontColor = #colorLiteral(red: 0.8673595786, green: 0.8812954426, blue: 0.8903576732, alpha: 1)

//        static let colorsFromDictionary = false
//        static let iconColor = fontColor
    
//    ALTERNATES
    static let colorsFromDictionary = false
    static let tileColor = #colorLiteral(red: 0.9750371575, green: 0.9692406058, blue: 0.9794927239, alpha: 1)
    static let backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let fontColor = #colorLiteral(red: 0.1138141975, green: 0.1143484786, blue: 0.1156276539, alpha: 1)
    static let iconColor = fontColor
    static let confirmedColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)

}
