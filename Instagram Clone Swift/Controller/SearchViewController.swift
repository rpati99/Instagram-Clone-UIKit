//
//  SearchViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 31/01/21.
//

import UIKit
import Firebase

class SearchViewController: UICollectionViewController {
    
     //MARK: - Elements
    var users = [User]()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.autocapitalizationType = .none
        return searchBar
    }()
    
   
     //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.collectionView.register(UserCell.self, forCellWithReuseIdentifier: usersCellID)
        doSearch()
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
    func doSearch() {
        if let searchText = searchBar.text {
            self.users.removeAll()
            self.collectionView.reloadData()
            UserService.shared.queryUsers(withText: searchText) { (user) in
                self.isFollowingUser(userID: user.id!,completed: { (value) in
                    user.isFollowing = value
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.frame.size.width = view.frame.size.width - 60
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.navigationController?.navigationBar.tintColor = .black
        
        searchBar.delegate = self
    }
    
}

    
// MARK: UICollectionViewDataSource

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: usersCellID, for: indexPath) as! UserCell
        cell.user = users[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = UserViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.userId = users[indexPath.item].id!
        navigationController?.pushViewController(controller, animated: true)
    }
}

 //MARK: - SearchBar delegate methods
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       doSearch()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
    
    
}


