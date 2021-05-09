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
    
    var pendingPostSend = false
    var postTransparency : CGFloat = 0.5
    var currentUserName : String?
    
    var imageString : String?
    var friend : String?
    var friendEmail : String?
    var messages : [Any] = []
    
    var initialMessageCount = 0
    
    var postToSend : Post?
    var sendingPost : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        self.navigationItem.title = friend
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        
        messagesTableView.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "MessagesTableViewCell")
        messagesTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        
        
        getMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.backgroundColor = K.backgroundColor
        messagesTableView.backgroundColor = K.backgroundColor
        messageTextView.layer.cornerRadius = 5
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if view.frame.origin.y == 0 {
                if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
                    view.frame.origin.y -= (keyboardHeight - tabBarHeight)
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
                if self.postToSend != nil {
                    let indexPath = IndexPath(row: self.messages.count - 1 + 1, section: 0)
                    self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    if self.initialMessageCount == 0 {
                        self.initialMessageCount = self.messages.count
                        print("Googoogaga")
                        print(self.initialMessageCount)
                    }
                }
                else {
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
            
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        let dateAbsolute = Date().timeIntervalSince1970
        
        let date = Date()
        
        let formatterShort = DateFormatter()
        formatterShort.dateStyle = .short
        formatterShort.timeStyle = .short
        
        let formatterLong = DateFormatter()
        formatterLong.dateStyle = .long
        formatterLong.timeStyle = .long
        
        let dateTimeShort = formatterShort.string(from: date)
        let dateTimeLong = formatterLong.string(from: date)
        
        if pendingPostSend {
            postTransparency = 1
            messagesTableView.reloadData()
            pendingPostSend = false
            
            db.collection("Users").document((Auth.auth().currentUser?.email!)!).collection("Messages").document(friendEmail!).collection("Messages").document(dateTimeLong).setData(
                
                ["text": postToSend!.postText!,
                 "date": postToSend!.date!,
                "category": postToSend!.category!,
                "creator": postToSend!.creator!,
                "blurb" : postToSend!.blurb!,
                "rating": postToSend!.rating!,
                "dateString" : postToSend!.dateString!])
            
            db.collection("Users").document(friendEmail!).collection("Messages").document((Auth.auth().currentUser?.email)!).collection("Messages").document(dateTimeLong).setData(
                
                ["text": postToSend!.postText!,
                 "date": postToSend!.date!,
                "category": postToSend!.category!,
                "creator": postToSend!.creator!,
                "blurb" : postToSend!.blurb!,
                "rating": postToSend!.rating!,
                "dateString" : postToSend!.dateString!])
//
//            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2
//            cell.profilePic.loadAndCacheImage(urlString: (postToSend?.profilePicURL)!)
//            cell.userEmail.setTitle( postToSend?.username, for: .normal)
//            cell.dateString.text = postToSend?.dateString
//            cell.friendsPostTextView.text = postToSend?.postText
//            cell.categoryIcon.image = K.categoryIcons[(postToSend?.category)!]!!
//            cell.categoryIcon.tintColor = K.categoryColorsSingular[(postToSend?.category)!]
//            cell.creatorTextView.text = postToSend?.creator
        }
        else {
            let messageText = messageTextView.text

            if messageText != "" {
                db.collection("Users").document((Auth.auth().currentUser?.email)!).collection("Messages").document(friendEmail!).collection("Messages").document(dateTimeLong).setData (
                    
                    ["sender" : (Auth.auth().currentUser?.email)!,
                     "recipient" : friendEmail!,
                     "text" : messageText!,
                     "dateString" : dateTimeShort,
                     "date" : dateAbsolute])
                
                db.collection("Users").document((Auth.auth().currentUser?.email)!).collection("Messages").document(friendEmail!).setData(["lastMessage" : messageText!, "lastMessageTime" : dateTimeShort, "name" : friend!, "email" : friendEmail!, "picURL" : imageString!])
                
                db.collection("Users").document(friendEmail!).collection("Messages").document((Auth.auth().currentUser?.email)!).collection("Messages").document(dateTimeLong).setData (
                    
                    ["sender" : (Auth.auth().currentUser?.email)!,
                     "recipient" : friendEmail!,
                     "text" : messageText!,
                     "dateString" : dateTimeShort,
                     "date" : dateAbsolute])
                
                db.collection("Users").document(friendEmail!).collection("Messages").document((Auth.auth().currentUser?.email)!).setData(["lastMessage" : messageText!, "lastMessageTime" : dateTimeShort, "name" : currentUserName!, "email" : (Auth.auth().currentUser?.email!)!, "picURL" : K.currentUserPicURL])
                
                messageTextView.text = ""
            }
        }
        
        
        
    }
    
    @IBAction func tableViewTriggerPressed(_ sender: UIButton) {
        self.dismissKeyboard()
    }
}

extension ConvoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postToSend != nil {
            return messages.count + 1
        }
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != initialMessageCount && indexPath.row < messages.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell") as! MessagesTableViewCell
            cell.parentConvoVC = self
            
            var tooLong = false;
            cell.messageTrailing.isActive = false
            cell.messageLeading.isActive = false
            
            cell.messageText.text = (messages[indexPath.row] as! Message).text
            
            if (messages[indexPath.row] as! Message).text!.count > 45 {
                tooLong = true
            }
            
            if (messages[indexPath.row] as! Message).senderEmail == (Auth.auth().currentUser?.email)! {
                cell.messageTrailing.isActive = true
                cell.messageTrailing.constant = 10
                
                if tooLong {
                    cell.messageLeading.isActive = true
                    cell.messageLeading.constant = 80
                }
            }
            
            else if (messages[indexPath.row] as! Message).senderEmail == friendEmail{
                cell.messageLeading.isActive = true
                cell.messageLeading.constant = 10
                
                if tooLong {
                    cell.messageTrailing.isActive = true
                    cell.messageTrailing.constant = 80
                }
            }
            //
            cell.messageView.layer.cornerRadius = 10
            cell.messageView.layer.masksToBounds = true
            
            cell.messageText.sizeToFit()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsPostsTableViewCell") as! FriendsPostsTableViewCell
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2
        cell.profilePic.loadAndCacheImage(urlString: (postToSend?.profilePicURL)!)
        cell.userEmail.setTitle( postToSend?.username, for: .normal)
        cell.dateString.text = postToSend?.dateString
        cell.friendsPostTextView.text = postToSend?.postText
        cell.categoryIcon.image = K.categoryIcons[(postToSend?.category)!]!!
        cell.categoryIcon.tintColor = K.categoryColorsSingular[(postToSend?.category)!]
        cell.creatorTextView.text = postToSend?.creator
        
        cell.userView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.userView.layer.cornerRadius = cell.userView.frame.height/4.5
        
        cell.creatorTextView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cell.creatorTextView.layer.cornerRadius = cell.userView.frame.height/4.5
        
        cell.profilePic.alpha = postTransparency
        cell.userEmail.alpha = postTransparency
        cell.userView.alpha = postTransparency
        cell.friendsPostTextView.alpha = postTransparency
        cell.creatorTextView.alpha = postTransparency
        cell.categoryIcon.alpha = postTransparency
        cell.dateString.alpha = postTransparency
        
        return cell
    }
    
}


