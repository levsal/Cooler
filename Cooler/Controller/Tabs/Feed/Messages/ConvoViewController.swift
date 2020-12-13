//
//  ConvoViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/12/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase

class ConvoViewController: UIViewController {
    
    let db = Firestore.firestore()
  
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var friendName: UIButton!
    @IBOutlet var messagesTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    
    var imageString : String?
    var friend : String?
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.loadAndCacheImage(urlString: imageString!)
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        
        friendName.setTitle(friend, for: .normal)
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
                
        messagesTableView.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "MessagesTableViewCell")
        
        messageTextField.delegate = self


        
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        let messageText = messageTextField.text
        let dateReversed = -Date().timeIntervalSince1970

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        let dateTime = formatter.string(from: date)
        
        
    }
}

extension ConvoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell") as! MessagesTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

extension ConvoViewController: UITextFieldDelegate {
    
}
