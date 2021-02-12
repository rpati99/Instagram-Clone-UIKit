//
//  ProfileHeaderCell.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 29/01/21.
//

import UIKit
import Firebase

protocol  ProfileHeaderCellDelegate {
    func buttonTapped()
}

class ProfileHeaderCell: UICollectionViewCell {
    
     //MARK: - Elements
    
    var profileVC: ProfileViewController!
    var delegate: ProfileHeaderCellDelegate?
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    var postCount: Int!
    
    
    private let profileImageView: UIImageView =
        {
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
    
    private let editProfileButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        return button
    }()
    
    private lazy var profileStatContainerView: UIView = {
        let view = UIView()
        view.addSubview(combinedStack)
        combinedStack.centerX(inView: view)
        combinedStack.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        view.addSubview(editProfileButton)
        editProfileButton.centerX(inView: view)
        editProfileButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8,height: 30)
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
    
  // MARK: - selectoers
    @objc func presentSettingsVC() {
        self.delegate?.buttonTapped()
    }
    
 
  
     //MARK: - Helpers
    func updateView() {
        guard let user = user else { return }
        self.nameLabel.text = user.username
        guard let profileImageUrl = user.profileImageUrl else { return }
        self.profileImageView.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
        if let postCount = postCount {
            postAmtLabel.text = "\(postCount)"
        }
       
        FollowService.shared.fetchFollowingCount(userID: user.id!) { (count) in
            self.followingAmtLabel.text = "\(count)"
        }
        
        FollowService.shared.fetchFollowersCount(userID: user.id!) { (count) in
            self.followersAmtLabel.text = "\(count)"
        }

    }
    
    func setupUI() {
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        addSubview(profileStatContainerView)
        profileStatContainerView.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor,paddingTop: 20, paddingLeft: 8, paddingRight: 16, height: 100)
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 17, paddingLeft: 16)
        editProfileButton.addTarget(self, action: #selector(presentSettingsVC), for: .touchUpInside)
        
    }
}
