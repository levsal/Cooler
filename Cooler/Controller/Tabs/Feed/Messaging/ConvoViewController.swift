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

  
    @IBOutlet var messagesTableView: PositionCorrectingTableView!
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var textFieldToBottom: NSLayoutConstraint!
    @IBOutlet var textViewStack: UIStackView!
    @IBOutlet var tableViewToTop: NSLayoutConstraint!
    
    var currentUserName : String?
    
    var imageString : String?
    var friend : String?
    var friendEmail : String?
    var messages : [Message] = []
    
    var messageLengths : [Int : CGFloat] = [:]
    var firstLoad = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        self.navigationItem.title = friend

        messagesTableView.dataSource = self
        messagesTableView.delegate = self
                
        messagesTableView.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "MessagesTableViewCell")
        

        getMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if view.frame.origin.y == 0 {
                if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
                    view.frame.origin.y -= (keyboardHeight - tabBarHeight)
//                    tableViewToTop.constant += (keyboardHeight - tabBarHeight)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if view.frame.origin.y != 0 {
                if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
                    view.frame.origin.y += (keyboardHeight - tabBarHeight)
//                    tableViewToTop.constant -= (keyboardHeight - tabBarHeight)

                }
            }
            
        }
    }
    
    
    func getMessages() {
        
        db.collection("Users").document((Auth.auth().currentUser?.email)!).collection("Messages").document(friendEmail!).collection("Messages").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error {
                print ("Error loading messages, \(e)")
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let text = data["text"],
                           let date = data["date"],
                           let dateString = data["dateString"],
                           let sender = data["sender"],
                           let recipient = data["recipient"] {
                            
                            self.messages.append(Message(senderEmail: sender as? String,
                                                         senderName: nil,
                                                         recipientEmail: recipient as? String,
                                                         recipientName: nil,
                                                         text: text as? String,
                                                         date: date as? Double,
                                                         dateString: dateString as? String,
                                                         picURL: nil))
                        }
                    }
                    
                    self.messagesTableView.reloadData()

                }
            }
            if self.messages.count != 0 {
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
            
        }
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        
        let messageText = messageTextView.text

        let dateAbsolute = Date().timeIntervalSince1970

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long

        let dateTime = formatter.string(from: date)

        if messageText != "" {
            db.collection("Users").document((Auth.auth().currentUser?.email)!).collection("Messages").document(friendEmail!).collection("Messages").document(dateTime).setData (
                
                ["sender" : (Auth.auth().currentUser?.email)!,
                 "recipient" : friendEmail!,
                 "text" : messageText!,
                 "dateString" : dateTime,
                 "date" : dateAbsolute])
            
            db.collection("Users").document((Auth.auth().currentUser?.email)!).collection("Messages").document(friendEmail!).setData(["lastMessageTime" : dateTime, "name" : friend!, "email" : friendEmail!, "picURL" : imageString!])
            
            db.collection("Users").document(friendEmail!).collection("Messages").document((Auth.auth().currentUser?.email)!).collection("Messages").document(dateTime).setData (
                
                ["sender" : (Auth.auth().currentUser?.email)!,
                 "recipient" : friendEmail!,
                 "text" : messageText!,
                 "dateString" : dateTime,
                 "date" : dateAbsolute])
            
            db.collection("Users").document(friendEmail!).collection("Messages").document((Auth.auth().currentUser?.email)!).setData(["lastMessageTime" : dateTime, "name" : currentUserName!, "email" : (Auth.auth().currentUser?.email!)!, "picURL" : K.currentUserPicURL])
            
            messageTextView.text = ""
        }

        
    }
}

extension ConvoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell") as! MessagesTableViewCell
        
        var tooLong = false;
        cell.messageTrailing.isActive = false
        cell.messageLeading.isActive = false

        cell.messageText.text = messages[indexPath.row].text
       
        
        let screenWidth = UIScreen.main.bounds.width

        print(cell.messageText.frame.width)
        if messages[indexPath.row].text!.count > 50 {
            tooLong = true
            print(messages[indexPath.row].text!)
        }
        
        if messages[indexPath.row].senderEmail == (Auth.auth().currentUser?.email)! {
            cell.messageTrailing.isActive = true
            cell.messageTrailing.constant = 10
           
            if tooLong {
                cell.messageLeading.isActive = true
                cell.messageLeading.constant = 80
            }
        }

        else if messages[indexPath.row].senderEmail == friendEmail{
            cell.messageLeading.isActive = true
            cell.messageLeading.constant = 10
           
            if tooLong {
                cell.messageTrailing.isActive = true
                cell.messageTrailing.constant = 80
            }
        }
//
        cell.messageView.layer.cornerRadius = 8
        cell.messageView.layer.masksToBounds = true
        
        cell.messageText.sizeToFit()

        return cell
    }
}


