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

  
    @IBOutlet var messagesTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var textFieldToBottom: NSLayoutConstraint!
    @IBOutlet var textViewStack: UIStackView!
    @IBOutlet var tableViewToTop: NSLayoutConstraint!
    
    var imageString : String?
    var friend : String?
    var friendEmail : String?
    var messages : [Message] = []
    
    var messageLineCount = 1
    var firstLoad = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.navigationItem.backBarButtonItem?.tintColor = .white

        
//        let imageView = UIImageView(frame: CGRect(x: -20, y: 0, width: 40, height: 40))
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = 20
        
        self.navigationItem.title = friend

        messagesTableView.dataSource = self
        messagesTableView.delegate = self
                
        messagesTableView.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "MessagesTableViewCell")
        
        messageTextField.delegate = self

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
                    if self.messages.count != 0 {
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                    
                }
            }
        }
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        
        let messageText = messageTextField.text
        let dateAbsolute = Date().timeIntervalSince1970

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long

        let dateTime = formatter.string(from: date)
        
        

        db.collection("Users").document((Auth.auth().currentUser?.email)!).collection("Messages").document(friendEmail!).collection("Messages").document(dateTime).setData (

            ["sender" : (Auth.auth().currentUser?.email)!,
             "recipient" : friendEmail!,
             "text" : messageText!,
             "dateString" : dateTime,
             "date" : dateAbsolute])

        db.collection("Users").document((Auth.auth().currentUser?.email)!).collection("Messages").document(friendEmail!).setData(["lastMessageTime" : dateTime])

        db.collection("Users").document(friendEmail!).collection("Messages").document((Auth.auth().currentUser?.email)!).collection("Messages").document(dateTime).setData (

            ["sender" : (Auth.auth().currentUser?.email)!,
             "recipient" : friendEmail!,
             "text" : messageText!,
             "dateString" : dateTime,
             "date" : dateAbsolute])

        db.collection("Users").document(friendEmail!).collection("Messages").document((Auth.auth().currentUser?.email)!).setData(["lastMessageTime" : dateTime])

        messageTextField.text = ""

        
    }
}

extension ConvoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell") as! MessagesTableViewCell
        
        
        let screenWidth = UIScreen.main.bounds.width

        cell.messageText.text = messages[indexPath.row].text
        
        let messageLength = cell.messageText.intrinsicContentSize.width + CGFloat(15)
        cell.messageWidth.constant = messageLength
    
        cell.messageText.layer.cornerRadius = 8
        cell.messageText.layer.masksToBounds = true

        if messages[indexPath.row].senderEmail == (Auth.auth().currentUser?.email)! {
            print(messages[indexPath.row].senderEmail! + " " + messages[indexPath.row].text!)
            cell.messageLeading.constant = screenWidth - 15 - cell.messageWidth.constant
            cell.messageTrailing.constant = 15
        }
        else if messages[indexPath.row].senderEmail == friendEmail{
            print(messages[indexPath.row].senderEmail! + " " + messages[indexPath.row].text!)

            cell.messageLeading.constant = 15
            cell.messageTrailing.constant = screenWidth - 15 - cell.messageWidth.constant

        }

        
        
        
        if cell.messageWidth.constant > screenWidth - 80 {
            cell.messageText.numberOfLines = Int(messageLength / (screenWidth-80)) + 1
            cell.messageWidth.constant = screenWidth - 80
        }
        
        messageLineCount = cell.messageText.numberOfLines

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60 * messageLineCount)
    }
    
    
}

extension ConvoViewController: UITextFieldDelegate {
    
}
