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
    @IBOutlet var list: UIButton!
    
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
    
    var categories : [String] = []
    
    var selectedCategories : [String] = []
    
    var postOpen : [String: Bool] = [:]
    
    var isHost : Bool = true
    var resetSelecteds = true
    var picFromCell = false
    var firstLoad = true
    var firstPicLoad = true
    var needCategories = true
    
    var posts: [Post] = []
    var friends : [Friend] = []
    
    var addFriendHidden = true
    
    let postVC: PostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postViewController") as! PostViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
     
//        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.06139858812, green: 0.06141700596, blue: 0.06139617413, alpha: 1)

        addFriendButton.setTitle(friendStatusButton, for: .normal)
        addFriendButton.setTitleColor(friendStatusColor, for: .normal)
        
        
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
        list.isHidden = true
        
        if isHost {
            email = (Auth.auth().currentUser?.email!)!
            settings.isHidden = false
            list.isHidden = false
        }
        
        loadProfilePage(email: email)

        loadPosts(from: selectedCategories)
        
        //        Get Profile Pic if the pic isn't being passed from a selected Post cell
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
        
        self.categoryCollectionView.reloadData()

    }
    
    
    
    func getCategories() {
        db.collection("Users").addSnapshotListener { [self] (querySnapshot, error) in
            if let e = error {
                print("Error finding user's categories, \(e)")
            } else {
                while(selectedCategories == []){
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let email = data["email"]{
                                if email as! String == self.email {
                                    if let categories = data["Artforms"] {
                                        //                                    print(categories)
                                        self.categories = categories as? [String] ?? []
                                        
                                        //Populate Selected Categories with User's Categories, Minus the Pluralization
                                        for category in self.categories {
                                            selectedCategories.append(String(category.dropLast()))
                                        }
                                        print(self.categories)
                                        print(self.selectedCategories)
                                        
                                        
                                        self.categoryCollectionView.reloadData()
                                        self.loadPosts(from: self.selectedCategories)
                                        self.postTableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        

    }
    func loadProfilePage(email : String){
        getName(user: email)
        getFriends(of: email)
        getCategories()
        
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
            postOpen[post.postText!] = false
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
    
    func loadPosts(from categories: [String]){
        
        db.collection("Users").document(email).collection("Posts").order(by: "date").addSnapshotListener { (querySnapshot, error) in
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
                            for cat in categories {
                                if let category = data["category"]{
                                    if category as! String == cat {
                                        self.posts.append(Post(date: date as? Double, dateString: dateString as? String, postText: postText as? String, category: category as? String, creator: creator as? String, blurb: blurb as? String, rating: givenRating as? Double))
                                    }
                                }
                            }
                            
                        }
                        DispatchQueue.main.async {
                            
                            self.postTableView?.reloadData()
                        }
                    }
                    self.assignValuesToPostOpen()
                    
                    self.postsCountValue = "" + String(self.posts.count) + " posts"
                    if let pCount = self.postsCount {
                        pCount.setTitle(self.postsCountValue, for: .normal)
                    }
                    
                }
            }
        }
    }
    
    func getFriends(of email : String) {
        
        db.collection("Users").document(email).collection("Friends").order(by: "date").addSnapshotListener { [self] (querySnapshot, error) in
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

                    
                    self.friendsCountValue = "" + String(self.friends.count) + " friends"
                    if let fCount = self.friendsCount {
                        fCount.setTitle(self.friendsCountValue, for: .normal)
                        
                    }
                }
            }
        }
        
        
        
    }
    
    
    @IBAction func addFriendPressed(_ sender: UIButton) {
        
        if sender.titleLabel!.text == "Add Friend" {
            
            db.collection("Users").document(Auth.auth().currentUser!.email!).collection("Friends").document(email).setData(["date" : Date().timeIntervalSince1970, "email": email, "name": usernameString, "picURL" : picURL])
            
//            db.collection("\(Auth.auth().currentUser!.email!)_Friends").document(email).setData(["date" : Date().timeIntervalSince1970, "email": email, "name": usernameString, "picURL" : picURL])
            
            
            print([email,usernameString, picURL])
//            print("Potential Friends Are \(String(describing: parentVC?.parentCell?.potentialFriends!))")
            
            parentVC?.parentCell?.collectionView.reloadData()
            
            parentVC?.parentCell?.parentFeedVC?.feedTableView.reloadData()
            let index = parentVC?.parentCell?.potentialFriends!.firstIndex(of: [email, usernameString, picURL])
//            print("Index is \(String(describing: index))")
            parentVC?.parentCell?.potentialFriends?.remove(at: index!)
            
            
            
            if parentVC == nil {
                sender.setTitle("Remove Friend", for: .normal)
                sender.setTitleColor(#colorLiteral(red: 1, green: 0.2305461764, blue: 0.1513932645, alpha: 1), for: .normal)
            }
        }
        else if sender.titleLabel!.text == "Remove Friend" {
            parentVC?.parentCell?.parentFeedVC?.feedTableView.reloadData()
            parentVC?.parentCell?.collectionView.reloadData()
            db.collection("Users").document(Auth.auth().currentUser!.email!).collection("Friends").document(email).delete()
            
//            db.collection("\(Auth.auth().currentUser!.email!)_Friends").document(email).delete()
            
//            print("Potential Friends Are \(String(describing: parentVC?.parentCell?.potentialFriends!))")
            
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
    
 
    @IBAction func listPressed(_ sender: UIButton) {
        let listVC: ListViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "listViewController") as! ListViewController
        
        listVC.parentProfileVC = self
        
        present(listVC, animated: true)
    }
    
    @IBAction func settingsPressed(_ sender: UIButton) {
        let userSettingsVC: UserSettingsViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "userSettingsViewController") as! UserSettingsViewController
        userSettingsVC.parentProfileVC = self
        present(userSettingsVC, animated: true)
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
//                        print("Gotta return")
                        return
                    }
                    let urlString = url.absoluteString
                    self.db.collection("Users").document(self.email).updateData(["picURL" : urlString])
                    //Update Profile Pic for All Users
                    self.db.collection("Users").addSnapshotListener { (querySnapshot, error) in
                        if let e = error {
                            print("Error finding user's name, \(e)")
                        } else {
                            if let snapshotDocuments = querySnapshot?.documents {
                                for doc in snapshotDocuments {
                                    let data = doc.data()
                                    if let userEmail = data["email"] as? String {
                                        print("\(userEmail)_Friends")

                                        self.db.collection("Users").document((userEmail)).collection("Friends").document(self.email).updateData(["picURL": urlString])
                                    }
                                }
                            }
                        }
                    }
                }
                
            }

            self.profilePic.image = image
           
            
            picker.dismiss(animated: true) {
                
            }
            
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
        
        cell.category.textColor = K.categoryColorsPlural[cell.category.text!]
        
        if selectedCategories == [String((cell.category.text?.dropLast())!)] {
            cell.underlined = true
    
        }
        else {
            cell.underlined = false
        }
        
        if cell.underlined {
            let attributedString = NSMutableAttributedString.init(string: (cell.category.text!))
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
            cell.category.attributedText = attributedString
        }
        else {
            let attributedString = NSMutableAttributedString.init(string: (cell.category.text!))
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 0, range: NSRange.init(location: 0, length: attributedString.length))
            cell.category.attributedText = attributedString
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let categoryCell = categoryCollectionView.cellForItem(at: indexPath)! as! CategoriesCollectionViewCell
        
        if categoryCell.underlined == false {
            let cat = (categoryCell.category.text!).dropLast()
            selectedCategories = [String(cat)]
        }
        else {
            selectedCategories = []
            for category in categories {
                selectedCategories.append(String(category.dropLast()))
            }
        }
        loadPosts(from: selectedCategories)
        categoryCollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if categories.count <= 4 {
            return CGSize(width:
                            CGFloat(collectionView.frame.size.width / CGFloat(categories.count)),
                          height:
                            CGFloat(24))
        }
        
        let throwawayLabel = UILabel()
        throwawayLabel.text = categories[indexPath.item]
        return CGSize(width: throwawayLabel.intrinsicContentSize.width + CGFloat(20), height: CGFloat(24))
       
        
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
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section <= posts.count - 1 {
            
            let cell = Bundle.main.loadNibNamed("FriendsPostsTableViewCell", owner: self, options: nil)?.first as! FriendsPostsTableViewCell
            
            cell.parentProfileVC = self
            
            cell.friendsPostTextView.text = posts[section].postText
            cell.creatorTextView.text = posts[section].creator
            
            cell.categoryIcon.image = K.categoryIcons[posts[section].category!]!!
            cell.categoryIcon.tintColor = K.categoryColorsSingular[posts[section].category!]

            cell.date = posts[section].date
            cell.category = posts[section].category
            cell.rating = posts[section].rating
            
            if isHost{
                cell.editButton.isHidden = false
            }
            
            if postOpen[posts[section].postText!]! {
                cell.openClosedArrow.image = UIImage(systemName: "chevron.down")
            }
            
            cell.friendsPostTextView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.friendsPostTextView.layer.cornerRadius = cell.friendsPostTextView.frame.height/4.5
            
            cell.creatorTextView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.creatorTextView.layer.cornerRadius = cell.friendsPostTextView.frame.height/4.5
            
            
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
            if postOpen[post.postText!] == false{
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
        cell.ratingValue.text = "\(String(describing: posts[indexPath.section].rating!))"
        cell.profileVC = self
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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



