//
//  ProfileViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit
import Firebase

class ProfileViewController: UICollectionViewController, ProfileHeaderCellDelegate {
  
    //MARK: - Elements
    var user: User!
    var posts = [Post]()
    
    
    
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
        UserService.shared.observeCurrentUser { (user) in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    

    func fetchUserPosts() {
        guard let currentUser = Auth.auth().currentUser else { return }
        DB_REF.child("myPosts").child(currentUser.uid).observe(.childAdded) { (snapshot) in
            PostService.shared.observePost(withID: snapshot.key) { (post) in
                    self.posts.append(post)
                    self.collectionView.reloadData()
            }
        }
    }

  
    
    // MARK: - Helpers
    func setupUI() {
        navigationItem.title = "Profile"
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: profileCellID)
        collectionView.register(ProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: profileHeaderID)
        let disImageIv = UIButton(type: .system)
        disImageIv.setDimensions(width: 30, height: 30)
        disImageIv.setImage(UIImage(named: "discover"), for: .normal)
        disImageIv.addTarget(self, action: #selector(handleDiscover), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: disImageIv)
       
    }


}

 //MARK: - CollectionView Delegates
extension ProfileViewController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileCellID, for: indexPath) as! ProfilePostCell
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
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileHeaderID, for: indexPath) as! ProfileHeaderCell
        header.postCount = posts.count
        if let user = self.user {
            header.user = user
            header.delegate = self
        }
        
        return header
    }
    
    // MARK: - HeaderDelegate methods
    func buttonTapped() {
        let settingsVC = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
}
