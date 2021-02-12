//
//  ExploreViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit

class ExploreViewController: UICollectionViewController {
     //MARK: - Elements
    
    var posts = [Post]()
    
    
    
    
    
    
     //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setupUI()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTopPosts()
    }
    
    

   
    
    
     //MARK: - Selectors
    
    @objc func handleSearchUser() {
        self.navigationController?.pushViewController(SearchViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
    
    
     //MARK: - API
    func loadTopPosts() {
        self.posts.removeAll()
        PostService.shared.observeTopPosts { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
        }
    }
    
     //MARK: - Helpers
    func setupUI() {
        collectionView.backgroundColor = .white
        navigationItem.title = "Explore"
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: discoverCellID)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchUser))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
    }

}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: discoverCellID, for: indexPath) as! ProfilePostCell
        cell.backgroundColor = .red
        cell.post = posts[indexPath.item]
        return cell
    }
}
