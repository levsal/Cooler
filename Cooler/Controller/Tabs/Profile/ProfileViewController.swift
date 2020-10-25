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
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    var email = ""
    var usernameString = ""
    var picURL = ""
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    var signOutButtonTitle = "Sign Out"
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBOutlet weak var friendsCount: UIButton!
    var friendsCountValue = ""
    @IBOutlet weak var postsCount: UIButton!
    var postsCountValue = ""
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var postTableView: PositionCorrectingTableView!
    
    var categories : [String] = ["Albums", "Movies", "TV Shows", "Books"]
    
    var selectedCategories : [String] = []
    
    var categoryColorsSingular = ["Album": #colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1), "Movie": #colorLiteral(red: 0.8735565543, green: 0.705497086, blue: 0.1316877007, alpha: 1), "TV Show": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1), "Book": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    var categoryColorsSingularPale = ["Album": #colorLiteral(red: 0.7195122838, green: 0.7771759033, blue: 0.9829060435, alpha: 1), "Movie": #colorLiteral(red: 0.8376982212, green: 0.8472841382, blue: 0.4527434111, alpha: 1), "TV Show": #colorLiteral(red: 0.6429418921, green: 0.8634710908, blue: 0.6248642206, alpha: 1), "Book": #colorLiteral(red: 0.886295557, green: 0.6721803546, blue: 0.6509570479, alpha: 1), "N/A": #colorLiteral(red: 0.3980969191, green: 0.4254524708, blue: 0.4201924801, alpha: 1)]
    var categoryColorsPlural = ["Albums": #colorLiteral(red: 0.5018746257, green: 0.6073153615, blue: 0.9935619235, alpha: 1), "Movies": #colorLiteral(red: 0.8735565543, green: 0.705497086, blue: 0.1316877007, alpha: 1), "TV Shows": #colorLiteral(red: 0.4808345437, green: 0.7886778712, blue: 0.4316937923, alpha: 1), "Books": #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), "N/A": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    
    var categoryIcons = ["Album": UIImage(systemName: "music.note"), "Movie": UIImage(systemName: "film"), "TV Show": UIImage(systemName: "tv"), "Book": UIImage(systemName: "book"), "N/A": UIImage(systemName: "scribble")]
    
    var postOpen : [String: Bool] = [:]
    
    var isHost : Bool = true
    var resetSelecteds = true
    
    var posts: [Post] = []
    var friends : [String] = []
    
    var addFriendHidden = true
    
    let postVC: PostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postViewController") as! PostViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
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
        postsCount.setTitle(postsCountValue, for: .normal)
        friendsCount.setTitle(friendsCountValue, for: .normal)
        
        if isHost {
            email = (Auth.auth().currentUser?.email!)!
            loadProfilePage(email: email)
        }
        loadPosts(from: selectedCategories)

        //Get Profile Pic
        self.db.collection("Users").document(self.email).addSnapshotListener { (docSnapshot, error) in
            if let documentSnapshot = docSnapshot {
                let data = documentSnapshot.data()
                if let url = data?["picURL"] {
                    self.picURL = url as! String
                    
                    self.profilePic.loadAndCacheImage(urlString: self.picURL)
                }
            }
        }

        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        postTableView?.dataSource = self
        postTableView.delegate = self
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
        present(postVC, animated: true)
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
                    
                    self.postsCountValue = "Posts: \(self.posts.count)"
                    if let pCount = self.postsCount {
                        pCount.setTitle("Posts: \(self.posts.count)", for: .normal)
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
                        if let friend = data["email"] {
                            self.friends.append(friend as! String)
                        }
                    }
                    
                    self.friendsCountValue = "Friends: \(self.friends.count)"
                    if let fCount = self.friendsCount {
                        fCount.setTitle("Friends: \(self.friends.count)", for: .normal)
                        
                    }
                }
            }
        }
        
        
    }
    
    
    @IBAction func addFriendPressed(_ sender: UIButton) {
        print("Current user is \(Auth.auth().currentUser!.email!)")
        print("Adding friend \(username.text!)")
        
        db.collection("\(Auth.auth().currentUser!.email!)_Friends").document(email).setData(["date" : Date().timeIntervalSince1970, "email": email, "name": usernameString])
        let index = parentVC?.parentCell?.potentialFriends?.firstIndex(of: [email, usernameString, picURL])
        parentVC?.parentCell?.potentialFriends?.remove(at: index!)
//        parentVC?.parentCell?.fetchUsers()
        parentVC?.parentCell?.collectionView.reloadData()
        
//        parentVC?.parentCell?.potentialFriends = []
//        parentVC?.parentCell?.fetchUsers()
//        parentVC?.parentCell?.collectionView.reloadData()
        print(parentVC?.parentCell?.potentialFriends)
        
        self.dismiss(animated: true) {
            
        }
    }
    
    //MARK: - Image Picker Controller
    
    @IBAction func profilePicTriggerPressed(_ sender: UIButton) {
        if isHost {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.mediaTypes = ["public.image", "public.movie"]
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.profilePic.image = image

        let storageRef = Storage.storage().reference().child("\(( Auth.auth().currentUser?.email!)!)_ProfilePic")
        
        if let uploadData = image.pngData(){
            storageRef.putData(uploadData)
            
            storageRef.downloadURL { (url, error) in
                guard let url = url, error == nil else{
                    return
                }
                let urlString = url.absoluteString
                self.db.collection("Users").document((Auth.auth().currentUser?.email)!).updateData(["picURL" : urlString])
                
                }
        
        
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
            
            //Make Plural Category Header Singular
            let genre = (categoryCell.category.text!).dropLast()
            selectedCategories = [String(genre)]
            
            //Reload Posts Based on Selected Category/Lack of Selection
            //            print(selectedCategories)
            loadPosts(from: (selectedCategories))
            categoryCell.underlined = true
        }
        else {
            //Underline Category
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 0, range: NSRange.init(location: 0, length: attributedString.length))
            categoryCell.category.attributedText = attributedString
            
            //            let exitingGenre = (sender.titleLabel?.text!)!.dropLast()
            selectedCategories = []
            for category in categories {
                selectedCategories.append(String(category.dropLast()))
            }
            //            print(selectedCategories)
            //          parentVC!.selectedCategories.filter { $0 != exitingGenre }
            
            loadPosts(from: (selectedCategories))
            categoryCell.underlined = false
            //            parentVC?.categoryCollectionView.reloadData()
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
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 0
    //    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section <= posts.count - 1 {
            
            let cell = Bundle.main.loadNibNamed("FriendsPostsTableViewCell", owner: self, options: nil)?.first as! FriendsPostsTableViewCell
            
            cell.parentProfileVC = self
            
            cell.friendsPostTextView.text = posts[section].postText
            cell.creatorTextView.text = posts[section].creator
            
            cell.friendsPostTextView.backgroundColor = categoryColorsSingular[posts[section].category]
            cell.creatorTextView.backgroundColor = categoryColorsSingularPale[posts[section].category]
            
            cell.categoryIcon.image = categoryIcons[posts[section].category]!!
            
            cell.userEmail.isHidden = true
            cell.dateString.isHidden = false
            cell.userEmail.heightAnchor.constraint(equalToConstant: 0).isActive = true
            
            return cell
        }
        else {
            return UIView()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
//        let rating = posts[indexPath.section].rating
//        var ratingColor = UIColor()
//        
//        if rating<3.0 {
//            ratingColor = #colorLiteral(red: 1, green: 0.1353616714, blue: 0.05722223222, alpha: 1)
//        }
//        else if rating < 6.0 {
//            ratingColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//        }
//        else if rating < 9.0 {
//            ratingColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
//        }
//        else if rating < 10.0 {
//            ratingColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//        }
//        else {
//            ratingColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//
//        }
//        cell.ratingValue.textColor = ratingColor
//        cell.ratingCircle.tintColor = ratingColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension ProfileViewController: PopoverDelegate {
    func appendToArray(post: Post) {
        posts.append(post)
    }
}

