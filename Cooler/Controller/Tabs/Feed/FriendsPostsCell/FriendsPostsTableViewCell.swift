//
//  FriendsPostsTableViewCell.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/30/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit

class FriendsPostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userEmail: UIButton!
    @IBOutlet weak var friendsPostTextView: UITextView!
    @IBOutlet weak var creatorTextView: UITextView!
    @IBOutlet weak var categoryIcon: UIImageView!
    
    var parentProfileVC : ProfileViewController?
    var parentFeedVC : FeedViewController?
    
    var sectionNumber = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func triggerPressed(_ sender: UIButton) {
        let work = friendsPostTextView.text
        
        //PROFILE
        if parentProfileVC?.postOpen[work!] == false{
            parentProfileVC?.postOpen[work!] = true
            
            parentProfileVC?.postTableView.reloadData()
            parentProfileVC?.postTableView.layoutIfNeeded()
            fixBottom(closed: true)
        }
        else if parentProfileVC?.postOpen[work!] == true{
            parentProfileVC?.postOpen[work!] = false
            
            parentProfileVC?.postTableView.reloadData()
            parentProfileVC?.postTableView.layoutIfNeeded()
            fixBottom(closed: false)
            
        }
        
        //FEED
        if parentFeedVC?.postOpen[work!] == false{
            parentFeedVC?.postOpen[work!] = true

            parentFeedVC?.feedTableView.reloadData()
            parentFeedVC?.feedTableView.layoutIfNeeded()
//            fixBottom(closed: true)
        }
        else if parentFeedVC?.postOpen[work!] == true{
            parentFeedVC?.postOpen[work!] = false

            parentFeedVC?.feedTableView.reloadData()
            parentFeedVC?.feedTableView.layoutIfNeeded()
//            fixBottom(closed: false)
            
        }
        
        //BOTH
        self.layoutIfNeeded()
        parentProfileVC?.postTableView.setContentOffset((parentProfileVC?.postTableView.offset)!, animated: false)
        parentFeedVC?.feedTableView.setContentOffset((parentFeedVC?.feedTableView.offset)!, animated: false)
        
    }
    
    
    
    
    
    
    
    
    func fixBottom(closed: Bool) {
        if parentProfileVC != nil {
            for post in parentProfileVC!.posts{
                if post.postText == friendsPostTextView.text {
                    sectionNumber = parentProfileVC!.posts.firstIndex(of: post)!
                    let indexPath = IndexPath(row: NSNotFound, section: sectionNumber)
                    //CHECK IF IT'S THE LAST ROW
                    if sectionNumber == (parentProfileVC?.posts.count)!-1 {
                        if closed {
                            parentProfileVC?.postTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                        }
                        else {
                            parentProfileVC?.postTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }
        }
        if parentFeedVC != nil {
            for post in parentFeedVC!.posts{
                if post.postText == friendsPostTextView.text {
                    sectionNumber = parentFeedVC!.posts.firstIndex(of: post)!
                    
                    let indexPath = IndexPath(row: NSNotFound, section: sectionNumber)
                    
                    //CHECK IF IT'S THE LAST ROW
                    if sectionNumber == (parentFeedVC?.posts.count)!-1 {
                        
                        if closed {
                            parentFeedVC?.feedTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                        }
                        else {
                            parentFeedVC?.feedTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                        
                    }
                    
                }
            }
        }
        
    }
}


