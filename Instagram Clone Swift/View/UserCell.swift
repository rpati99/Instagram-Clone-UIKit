//
//  UsersCell.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 29/01/21.
//

import UIKit
import Firebase

class UserCell: UICollectionViewCell {
    
     //MARK: - Elements
    var check: Bool!
    var userVC: SearchViewController?
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            guard let username = user?.username else { return }
            profileImageView.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
            usernameLabel.text = username
            
            if user!.isFollowing! {
                followButton.setTitle("Done", for: .normal)
                followButton.backgroundColor = .green
                check = true
            } else {
                check = false
            }
            
            
            
        }
    }
    
    
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView().createProfileImageView(width: 60, height: 60)
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel().topLabel(title: "", weight: .regular)
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton().makeBlackBackgroundButton(title: "Follow")
        return button
    }()
    
     //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
   
     func handleFollowing() {
        if user!.isFollowing! == false {
            guard let userID = user?.id else { return }
            guard let currentUser = Auth.auth().currentUser else { return }
            FollowService.shared.handleFollow(userID: userID, currentUserID: currentUser.uid)
            //updating value here for faster loading times
            user!.isFollowing! = true
        }
    }
    
     func handleUnfollowing() {
        if user!.isFollowing! == true {
            guard let userID = user?.id else { return }
            guard let currentUser = Auth.auth().currentUser else { return }
            FollowService.shared.handleUnfollow(userID: userID, currentUserID: currentUser.uid)
            user!.isFollowing! = false
        }

    }

    // MARK: - API
  
    
     //MARK: - Helpers
    
   
    
    @objc func configureFollowButton() {
        if check == false {
            handleUnfollowing()
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .black
            check = true
        } else if check == true {
            handleFollowing()
            followButton.setTitle("Done", for: .normal)
            followButton.backgroundColor = .green
            check = false
        }

    }
    
    
    func setupUI() {
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 16)
        addSubview(usernameLabel)
        usernameLabel.centerY(inView: self)
        usernameLabel.anchor(left: profileImageView.rightAnchor, paddingLeft: 8)
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 8)
        followButton.addTarget(self, action: #selector(configureFollowButton), for: .touchUpInside)
       
        let seperatorView = UIView()
        seperatorView.backgroundColor = .gray
        addSubview(seperatorView)
        seperatorView.anchor( left: leftAnchor, bottom: bottomAnchor, right: rightAnchor ,height: 0.5)
    }
    
    
}
