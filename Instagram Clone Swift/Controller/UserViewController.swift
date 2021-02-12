//
//  UserViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 31/01/21.
//

import UIKit



import UIKit
import Firebase

class UserViewController: UICollectionViewController {
    

    //MARK: - Elements
    var user: User!
    var posts = [Post]()
    var userId = ""
    
    
     //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
        fetchUserPosts()
    }

    // MARK: - Selector
    @objc func handleDiscover() {
        print("DBG: Discover tapped")
        self.navigationController?.pushViewController(DiscoverViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
    
    // MARK: - API
    func fetchUser() {
        UserService.shared.observeCurrentUser(withID: userId) { (user) in
            self.isFollowingUser(userID: user.id!) { (success) in
                user.isFollowing = success
                self.user = user
                self.navigationItem.title = user.username
                self.collectionView.reloadData()
            }
        }
        
    }
    

    func fetchUserPosts() {
        DB_REF.child("myPosts").child(userId).observe(.childAdded) { (snapshot) in
            PostService.shared.observePost(withID: snapshot.key) { (post) in
                    self.posts.append(post)
                    self.collectionView.reloadData()
            }
        }
    }
    
    func isFollowingUser(userID: String, completed: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        FollowService.shared.isFollowingUser(userId: userID, currentUserID: currentUser.uid, completion: completed)
    }

  
    
    // MARK: - Helpers
    func setupUI() {
        navigationItem.title = "Profile"
        collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(UserProfilePostCell.self, forCellWithReuseIdentifier: userProfilePostCellID)
        collectionView.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: userProfileHeaderCellID)
        
    }


}

 //MARK: - CollectionView Delegates
extension UserViewController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userProfilePostCellID, for: indexPath) as! UserProfilePostCell
        cell.backgroundColor = .red
        cell.post = posts[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: userProfileHeaderCellID, for: indexPath) as! UserProfileHeaderCell
        header.postCount = posts.count
        if let user = self.user {
            header.user = user
            
        }
        
        return header
    }

    
}
