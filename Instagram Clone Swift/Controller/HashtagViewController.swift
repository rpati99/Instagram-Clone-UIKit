//
//  HashtagViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 10/02/21.
//

import UIKit

class HashtagViewController: UICollectionViewController {
    
    
    var hashtag: String!
    var posts = [Post]()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        return activityIndicator
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource  = self
        collectionView.backgroundColor = .white
        collectionView.addSubview(activityIndicator)
        activityIndicator.centerX(inView: view)
        activityIndicator.centerY(inView: view)
        activityIndicator.startAnimating()
        collectionView.register(HashtagPostCell.self, forCellWithReuseIdentifier: hashtagPostID)
        self.navigationItem.title = "#" + hashtag
        fetchHashtagPost(of: hashtag)
   
        
    }

     //MARK: - API
    
    
    
    func fetchHashtagPost(of hashtag: String) {
        DB_REF.child("hashtags").child(hashtag).observe(.childAdded) { (snapshot) in
            PostService.shared.observePost(withID: snapshot.key) { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
                print("DBG: \(post)")
            }
        }
    }

}

extension HashtagViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hashtagPostID, for: indexPath) as! HashtagPostCell
        cell.post = posts[indexPath.row]
        return cell 
    }
}
