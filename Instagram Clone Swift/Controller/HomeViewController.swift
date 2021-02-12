//
//  FeedViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit
import Firebase

class HomeViewController: UICollectionViewController {
    
     //MARK: - Elements
    
    var posts = [Post]()
    var users = [User]()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        return activityIndicator
    }()
    
 //MARK: - Application lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupUI()
    }
    
    
    
     //MARK: - Selector functions
    
 

    
    @objc func presentCommentVC() {
        navigationController?.pushViewController(CommentViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
        
    }
    

    
  


     //MARK: - API
    
    func fetchData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        FeedService.shared.observeFeed(withId: currentUser.uid) { (post) in
            self.fetchUser(uid: post.uid!) {
                self.posts.insert(post, at: 0)
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
            }
        }
        
        FeedService.shared.observeFeedRemoved(userID: currentUser.uid) { (post) in
            self.posts = self.posts.filter({  $0.id != post.id } )
            self.users = self.users.filter({  $0.id != post.uid } )
            self.collectionView.reloadData()
        }
        
        
    }
    
    func fetchUser(uid: String, _ completed: @escaping () -> Void)  {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = User.transformUser(dict: dict, key: snapshot.key)
            self.users.insert(user, at: 0)
            completed()
        }
    }

    
     //MARK: - Helper functions
    func setupUI() {
        collectionView.backgroundColor = .white
        activityIndicator.startAnimating()
        
        collectionView.addSubview(activityIndicator)
        activityIndicator.centerX(inView: view)
        activityIndicator.centerY(inView: view)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: postCellID)
        navigationItem.title = "Home"
        
    }
 



}

 //MARK: - CollectionView delegate methods

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellID, for: indexPath) as! PostCell
        cell.posts = posts[indexPath.item]
        cell.users = users[indexPath.item]
        cell.homeVC = self
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 520)
    }
    
}

extension HomeViewController: PostCellDelegate {

    
    func goToHashtag(tag: String) {
        let hashtagVC = HashtagViewController(collectionViewLayout: UICollectionViewFlowLayout())
        hashtagVC.hashtag = tag.lowercased()
        self.navigationController?.pushViewController(hashtagVC, animated: true)
        
    }
    
    
}

