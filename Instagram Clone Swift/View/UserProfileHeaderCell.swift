//
//  UserProfileCell.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 01/02/21.
//

import UIKit
import Firebase

class UserProfileHeaderCell: UICollectionViewCell {
    
     //MARK: - Elements
    var check: Bool!

    var user: User? {
        didSet {
            updateView()
        }
    }
    
    var postCount: Int!
    
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView().createProfileImageView(width: 80, height: 80)
        return iv
    }()
    
    
    private let postAmtLabel: UILabel = {
        let label = UILabel().topLabel(title: "\(0)", weight: .regular)
      
        return label
    }()
    
    private let postLabel: UILabel = {
        let label = UILabel().topLabel(title: "Posts", weight: .regular)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let followersAmtLabel: UILabel = {
        let label = UILabel().topLabel(title: "\(0)", weight: .regular)
        
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel().topLabel(title: "Followers", weight: .regular)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    
    private let followingAmtLabel: UILabel = {
        let label = UILabel().topLabel(title: "\(0)", weight: .regular)
        
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel().topLabel(title: "Following", weight: .regular)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var poststack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [postAmtLabel,postLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private lazy var followersstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ followersAmtLabel,followersLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private lazy var followingstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ followingAmtLabel,followingLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private lazy var combinedStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [poststack, followersstack, followingstack])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let followButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 2
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var profileStatContainerView: UIView = {
        let view = UIView()
        view.addSubview(combinedStack)
        combinedStack.centerX(inView: view)
        combinedStack.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        view.addSubview(followButton)
        followButton.centerX(inView: view)
        followButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8,height: 30)
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
     //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    // MARK: - Selectors
    @objc func configureFollowBtn() {
        print("DBG: \(check)")
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
    

  
     //MARK: - API
    
    func updateView() {
        guard let user = user else { return }
        self.nameLabel.text = user.username
        guard let profileImageUrl = user.profileImageUrl else { return }
        self.profileImageView.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
        if let postCount = postCount {
            postAmtLabel.text = "\(postCount)"
        }
        
        if user.id == Auth.auth().currentUser?.uid {
            followButton.setTitle("Edit Profile", for: .normal)
            followButton.layer.borderColor = UIColor.black.cgColor
            followButton.layer.borderWidth = 1
            followButton.layer.cornerRadius = 5
            followButton.setTitleColor(.black, for: .normal)
            followButton.backgroundColor = .systemGray6
            check = true
        } else {
            check = false
            updateStateFollowButton()
        }
        
        FollowService.shared.fetchFollowingCount(userID: user.id!) { (count) in
            self.followingAmtLabel.text = "\(count)"
        }
        
        FollowService.shared.fetchFollowersCount(userID: user.id!) { (count) in
            self.followersAmtLabel.text = "\(count)"
        }

    }
    
    func updateStateFollowButton() {
        if user!.isFollowing! {
            followButton.setTitle("Done", for: .normal)
            followButton.backgroundColor = .green
            check = false
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .black
            
        }

    }
    
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
    




    
    // MARK: - Helpers
    
    func setupUI() {
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        addSubview(profileStatContainerView)
        profileStatContainerView.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor,paddingTop: 20, paddingLeft: 8, paddingRight: 16, height: 100)
        followButton.addTarget(self, action: #selector(configureFollowBtn), for: .touchUpInside)
       addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 17, paddingLeft: 16)
        
    }
}
