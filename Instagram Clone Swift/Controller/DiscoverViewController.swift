//
//  DiscoverViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 29/01/21.
//

import UIKit
import Firebase

class DiscoverViewController: UICollectionViewController {
    
     //MARK: - Elements
    var users = [User]()
    
   
    
     //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUsers()
     
        self.collectionView.register(UserCell.self, forCellWithReuseIdentifier: usersCellID)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
     //MARK: - API
    func fetchUsers()  {
        REF_USERS.observe(.childAdded) { [self] (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = User.transformUser(dict: dict, key: snapshot.key)
            if user.id != Auth.auth().currentUser?.uid {
                self.isFollowingUser(userID: user.id!,completed: { (success) in
                    user.isFollowing = success
                    self.users.append(user)
                    self.collectionView.reloadData()
                })
            }
        }
    }
    
    func isFollowingUser(userID: String, completed: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        FollowService.shared.isFollowingUser(userId: userID, currentUserID: currentUser.uid, completion: completed)
    }

    
   
     //MARK: - Selectors
    
     
     //MARK: - Helpers
    
    func setupUI() {
        collectionView.backgroundColor = .white
        self.navigationItem.title = "Discover"
    }
    
}

    
// MARK: UICollectionViewDataSource

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = UserViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.userId = users[indexPath.item].id!
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: usersCellID, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}








