//
//  Message.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/12/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import Foundation

struct Message : Equatable {
    var senderEmail : String?
    var senderName : String?
    var recipientEmail : String?
    var recipientName : String?
    var text : String?
    var date : Double?
    var dateString: String?
    var picURL : String?
}
