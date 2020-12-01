//
//  ProfileViewController.swift
//  Cooler
//
//  Created by Levi Saltzman on 9/8/20.
//  Copyright © 2020 Levi Saltzman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

protocol PopoverDelegate {
    func appendToArray(post: Post)
}

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    let firebase = Storage.storage()
    
    var parentVC : AddFriendsCollectionViewCell?
    
    @IBOutlet weak var emptyTableViewLabel: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var bioTextField: UITextField!
    
    @IBOutlet var settings: UIButton!
    
    var email = ""
    var usernameString = ""
    var bio = ""
    var picURL = ""
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
    var signOutButtonTitle = "Sign Out"
    
    @IBOutlet weak var addFriendButton: UIButton!
    var friendStatusButton : String = "Add Friend"
    var friendStatusColor : UIColor = #colorLiteral(red: 0, green: 0.5851971507, blue: 0, alpha: 1)
    
    @IBOutlet weak var friendsCount: UIButton!
    var friendsCountValue = ""
    @IBOutlet weak var postsCount: UIButton!
    var postsCountValue = ""
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var postTableView: PositionCorrectingTableView!
    
    var categories : [String] = ["Albums", "Movies", "TV Shows", "Books"]
    
    var selectedCategories : [String] = []
    
    var categoryColorsSingular = ["Album": #colorLiteral(red: 0.5019607843, green: 0.6078431373, blue: 0.9921568627, alpha: 1), "Movie": #colorLiteral(red: 0.8745098039, green: 0.7058823529, blue: 0.1333333333, alpha: 1), "TV Show": #colorLiteral(red: 0.4823529412, green: 0.7882352941, blue: 0.431372549, alpha: 1), "Book": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    var categoryColorsSingularPale = ["Album": #colorLiteral(red: 0.7195122838, green: 0.7771759033, blue: 0.9829060435, alpha: 1), "Movie": #colorLiteral(red: 0.8376982212, green: 0.8472841382, blue: 0.4527434111, alpha: 1), "TV Show": #colorLiteral(red: 0.6429418921, green: 0.8634710908, blue: 0.6248642206, alpha: 1), "Book": #colorLiteral(red: 0.886295557, green: 0.6721803546, blue: 0.6509570479, alpha: 1), "N/A": #colorLiteral(red: 0.3980969191, green: 0.4254524708, blue: 0.4201924801, alpha: 1)]
    var categoryColorsPlural = ["Albums": #colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1), "Movies": #colorLiteral(red: 0.8745098039, green: 0.7058823529, blue: 0.1333333333, alpha: 1), "TV Shows": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1), "Books": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    
    var categoryIcons = ["Album": UIImage(systemName: "music.note"), "Movie": UIImage(systemName: "film"), "TV Show": UIImage(systemName: "tv"), "Book": UIImage(systemName: "book"), "N/A": UIImage(systemName: "scribble")]
    
    var postOpen : [String: Bool] = [:]
    
    var isHost : Bool = true
    var resetSelecteds = true
    var picFromCell = false
    var firstLoad = true
    var firstPicLoad = true
    
    var posts: [Post] = []
    var friends : [Friend] = []
    
    var addFriendHidden = true
    
    let postVC: PostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postViewController") as! PostViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFriendButton.setTitle(friendStatusButton, for: .normal)
        addFriendButton.setTitleColor(friendStatusColor, for: .normal)
        
        //Populate Selected Categories with User's Categories, Minus the Pluralization
        for category in categories {
            selectedCategories.append(String(category.dropLast()))
        }
        
        //Aesthetic Adjustments
        profilePic.layer.cornerRadius = profilePic.layer.frame.height/2
        addFriendButton.isHidden = addFriendHidden
        
        //Register Nibs for Collection and Table Views
        categoryCollectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        postTableView.register(UINib(nibName: "FriendsPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostsTableViewCell")
        postTableView.register(UINib(nibName: "PostDetailView", bundle: nil), forCellReuseIdentifier: "PostDetailView")
        
        signOutButton.title = signOutButtonTitle
        username.text = usernameString
        bioTextField.text = bio
        postsCount.setTitle(postsCountValue, for: .normal)
        friendsCount.setTitle(friendsCountValue, for: .normal)
        
        settings.isHidden = true
        
        if isHost {
            email = (Auth.auth().currentUser?.email!)!
            loadProfilePage(email: email)
            settings.isHidden = false
        }
        loadPosts(from: selectedCategories)
        
        //        Get Profile Pic if the pick isnt being passed from a selected Post cell
        if !picFromCell {
            self.db.collection("Users").document(self.email).addSnapshotListener { (docSnapshot, error) in
                if let e = error{
                    print("Error fetching User doc, \(e)")
                }
                else if self.firstPicLoad {
                    if let documentSnapshot = docSnapshot {
                        let data = documentSnapshot.data()
                        if let url = data?["picURL"] {
                            self.picURL = url as! String
                            
                            self.profilePic.loadAndCacheImage(urlString: self.picURL)
                        }
                        else {
                            self.picURL = "DISTORTO"
                        }
                    }
                    self.firstPicLoad = false
                }
            }
        }
        
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        postTableView?.dataSource = self
        postTableView.delegate = self
        
        if isHost{
            bioTextField.delegate = self
            bioTextField.isUserInteractionEnabled = true
        }
        else {
            bioTextField.isUserInteractionEnabled = false
        }
        
        
        postTableView.separatorColor = UIColor.clear
        postVC.delegate = self
    }
    func loadProfilePage(email : String){
        getName(user: email)
        getFriends(of: email)
    }
    
    func getName(user: String) {
        db.collection("Users").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("Error finding user's name, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let email = data["email"] as? String, let name = data["name"] as? String {
                            if email == user {
                                self.usernameString = name
                                if let uName = self.username {
                                    uName.text = name
                                }
                                if let bioText = data["bio"] as? String{
                                    print(bioText)
                                    self.bio = bioText
                                    if let bioField = self.bioTextField {
                                        bioField.text = bioText
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    func assignValuesToPostOpen() {
        for post in posts {
            postOpen[post.postText] = false
        }
        //        print(postOpen)
    }
    
    //Called from Category Cells
    func resetSelectedCategories() {
        if resetSelecteds {
            selectedCategories = []
            resetSelecteds = false
        }
    }
    
    
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        if postButton.title != "" {
            present(postVC, animated: true)
            
        }
    }
    
    @IBAction func friendsButtonPressed(_ sender: UIButton) {
        let friendsVC: FindFriendsViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "findFriendsViewController") as! FindFriendsViewController
        friendsVC.fromProfile = true
        friendsVC.friends = friends
        present(friendsVC, animated: true)
//        performSegue(withIdentifier: "ProfileToFindFriends", sender: self)
    }
    
    func loadPosts(from genres: [String]){
        
        db.collection("\(email)_Posts").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.posts = []
            //            print(self.posts)
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let postText = data["text"],
                           let date = data["date"],
                           let dateString = data["dateString"],
                           let creator = data["creator"],
                           let blurb = data["blurb"],
                           let givenRating = data["rating"] {
                            
                            //Filter by selected genre
                            for genre in genres {
                                if let category = data["category"]{
                                    if category as! String == genre {
                                        self.posts.append(Post(date: date as! Double, dateString: dateString as! String, postText: postText as! String, category: category as! String, creator: creator as! String, blurb: blurb as! String, rating: givenRating as! Double))
                                        //                                    print(self.posts)
                                    }
                                }
                            }
                            
                        }
                        DispatchQueue.main.async {
                            
                            self.postTableView?.reloadData()
                        }
                    }
                    self.assignValuesToPostOpen()
                    
                    self.postsCountValue = "Posts: " + String(self.posts.count)
                    if let pCount = self.postsCount {
                        pCount.setTitle(self.postsCountValue, for: .normal)
                    }
                    
                }
            }
        }
        
        
        
    }
    
    func getFriends(of email : String) {
        
        db.collection("\(email)_Friends").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.friends = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let email = data["email"],
                           let name = data["name"],
                           let picURL = data["picURL"]
                        {
                            self.friends.append(Friend(email: (email as! String), name: (name as! String), date: nil, picURL: (picURL as! String), bio: nil))
                        }
                    }
                    
                    self.friendsCountValue = "Friends: " + String(self.friends.count)
                    if let fCount = self.friendsCount {
                        fCount.setTitle(self.friendsCountValue, for: .normal)
                        
                    }
                }
            }
        }
        
        
    }
    
    
    @IBAction func addFriendPressed(_ sender: UIButton) {
        
        if sender.titleLabel!.text == "Add Friend" {
            
            db.collection("\(Auth.auth().currentUser!.email!)_Friends").document(email).setData(["date" : Date().timeIntervalSince1970, "email": email, "name": usernameString, "picURL" : picURL])
            
            
            print([email,usernameString, picURL])
            print("Potential Friends Are \(String(describing: parentVC?.parentCell?.potentialFriends!))")
            
            parentVC?.parentCell?.collectionView.reloadData()
            
            parentVC?.parentCell?.parentFeedVC?.feedTableView.reloadData()
            let index = parentVC?.parentCell?.potentialFriends!.firstIndex(of: [email, usernameString, picURL])
            print("Index is \(String(describing: index))")
            parentVC?.parentCell?.potentialFriends?.remove(at: index!)
            
            
            
            if parentVC == nil {
                sender.setTitle("Remove Friend", for: .normal)
                sender.setTitleColor(#colorLiteral(red: 1, green: 0.2305461764, blue: 0.1513932645, alpha: 1), for: .normal)
            }
        }
        else if sender.titleLabel!.text == "Remove Friend" {
            parentVC?.parentCell?.parentFeedVC?.feedTableView.reloadData()
            parentVC?.parentCell?.collectionView.reloadData()
            db.collection("\(Auth.auth().currentUser!.email!)_Friends").document(email).delete()
            
            print("Potential Friends Are \(String(describing: parentVC?.parentCell?.potentialFriends!))")
            
            if parentVC == nil{
                sender.setTitle("Add Friend", for: .normal)
                sender.setTitleColor(#colorLiteral(red: 0, green: 0.5851971507, blue: 0, alpha: 1), for: .normal)
                
            }
            
        }
        
        if parentVC != nil {
            self.dismiss(animated: true) {
                
            }
        }
        
    }
    
    //MARK: - Image Picker Controller
    
    @IBAction func profilePicTriggerPressed(_ sender: UIButton) {
        if isHost {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let storageRef = Storage.storage().reference().child("\((Auth.auth().currentUser?.email)!)_ProfilePic")
        
        if let uploadData = image.jpegData(compressionQuality:0.2){
            DispatchQueue.main.async {
                storageRef.putData(uploadData)
                
                storageRef.downloadURL { (url, error) in
                    guard let url = url, error == nil else{
                        print("Gotta return")
                        return
                    }
                    let urlString = url.absoluteString
                    self.db.collection("Users").document((Auth.auth().currentUser?.email)!).updateData(["picURL" : urlString])
                }
                
            }
            
            self.profilePic.image = image
            
            picker.dismiss(animated: true) {
                
            }
            print(image)
        }
    }
    
    //MARK: - Sign Out
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        if sender.title == "Sign Out" {
            print("SignOut Pressed")
            do {
                try Auth.auth().signOut()
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            performSegue(withIdentifier: "signOutSegue", sender: self)
        }
        else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
}

//MARK: - Collection View


extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        
        cell.parentVC = self
        
        cell.category!.text = categories[indexPath.item]
        cell.category.textColor = categoryColorsPlural[cell.category.text!]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("Did select Item at \(indexPath)")
        
        let categoryCell = categoryCollectionView.cellForItem(at: indexPath)! as! CategoriesCollectionViewCell
        //        print(categoryCell.underlined)
        
        let attributedString = NSMutableAttributedString.init(string: (categoryCell.category.text!))
        
        //If not selected cell, unhighlight
        for cell in categoryCollectionView.visibleCells {
            let catCell = cell as! CategoriesCollectionViewCell
            if catCell != categoryCell {
                let attributedString2 = NSMutableAttributedString.init(string: (catCell.category.text!))
                attributedString2.addAttribute(NSAttributedString.Key.underlineStyle, value: 0, range: NSRange.init(location: 0, length: attributedString2.length))
                catCell.category.attributedText = attributedString2
                catCell.underlined = false
            }
        }
        
        resetSelectedCategories()
        
        
        
        if categoryCell.underlined == false {
            
            //Underline Category
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
            categoryCell.category.attributedText = attributedString
            
            //Make Pluralized Category Header Singular
            let genre = (categoryCell.category.text!).dropLast()
            selectedCategories = [String(genre)]
            
            //Reload Posts Based on Selected Category/Lack of Selection
            loadPosts(from: (selectedCategories))
            categoryCell.underlined = true
        }
        else {
            
            //Underline Category
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 0, range: NSRange.init(location: 0, length: attributedString.length))
            categoryCell.category.attributedText = attributedString
            
            selectedCategories = []
            for category in categories {
                selectedCategories.append(String(category.dropLast()))
            }
            
            loadPosts(from: (selectedCategories))
            categoryCell.underlined = false
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.frame.size.width / CGFloat(categories.count))), height: CGFloat(20))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - Table View
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section <= posts.count - 1 {
            
            let cell = Bundle.main.loadNibNamed("FriendsPostsTableViewCell", owner: self, options: nil)?.first as! FriendsPostsTableViewCell
            
            cell.parentProfileVC = self
            
            cell.friendsPostTextView.text = posts[section].postText
            cell.creatorTextView.text = posts[section].creator
            
            cell.friendsPostTextView.backgroundColor = categoryColorsSingular[posts[section].category]
            cell.creatorTextView.backgroundColor = categoryColorsSingularPale[posts[section].category]
            cell.creatorTextView.textColor = .black
            
            cell.categoryIcon.image = categoryIcons[posts[section].category]!!
//            cell.stackHeight.constant = 120
            cell.iconWidth.constant = 25
            cell.iconHeight.constant = 25
            cell.iconOffset.constant = -80
            
//            cell.contentView.backgroundColor = .white
            
            cell.date = posts[section].date
            cell.category = posts[section].category
            cell.rating = posts[section].rating
            
            if isHost{
                cell.editButton.isHidden = false
            }
            
//            cell.userView.isHidden = true

            
            
            return cell
        }
        else {
            return UIView()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if posts.count == 0 && firstLoad == false{
            postTableView.isHidden = true
            emptyTableViewLabel.isHidden = false
        }
        else{
            emptyTableViewLabel.isHidden = true
            postTableView.isHidden = false
            
        }
        firstLoad = false
        return posts.count + 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return posts[section].postText
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= posts.count - 1 {
            let post = posts[section]
            if postOpen[post.postText] == false{
                return 0
            }
            else {
                return 1
            }
        }
        
        //WHITE SPACE
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailView", for: indexPath) as! PostDetailView
        cell.blurbTextView.text = posts[indexPath.section].blurb
        cell.ratingValue.text = "\(posts[indexPath.section].rating)"
        cell.profileVC = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension ProfileViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bioTextField.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        db.collection("Users").document(email).updateData(["bio" : bioTextField.text!])
    }
}

extension ProfileViewController: PopoverDelegate {
    func appendToArray(post: Post) {
        posts.append(post)
    }
}



