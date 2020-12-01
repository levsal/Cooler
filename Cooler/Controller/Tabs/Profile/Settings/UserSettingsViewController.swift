//
//  UserSettingsViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 12/1/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class UserSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var settingsTableView: UITableView!
    var categoryColorsPlural = ["Albums": #colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1),
                                "Movies": #colorLiteral(red: 0.8745098039, green: 0.7058823529, blue: 0.1333333333, alpha: 1),
                                "TV Shows": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1),
                                "Books": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
                                "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        
        settingsTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")

    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return categoryColorsPlural.count
        }
        if section == 1 {
            return 1
        }
        print("Googoogaga")
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = Bundle.main.loadNibNamed("SettingsTableViewCell", owner: self, options: nil)?.first as! SettingsTableViewCell
        cell.parentSettingsVC = self
        switch section {
        case 0:
            cell.headerButton.setTitle("Board Categories", for: .normal)
        case 1 :
            cell.headerButton.setTitle("Bio", for: .normal)
        default:
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    



}
