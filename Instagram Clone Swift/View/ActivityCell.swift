//
//  ActivityCell.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 11/02/21.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    // MARK: - Properties

    var notification: Notifications? {
        didSet {
            setupView()
        }
    }
    
    
    
    var users : User? {
        didSet {
           setupUserInfo()
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView().createProfileImageView(width: 40, height: 40)
        return iv
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView().createProfileImageView(width: 40, height: 40)
        iv.layer.cornerRadius = 0
        return iv
    }()
    
    private let personPostedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
      
        return label
    }()
    
    private let activityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
       
        switch notification!.type {
        case "feed":
            activityLabel.text = "added a new post"
            guard let postId = notification?.objectId else { return }
            PostService.shared.observePost(withID: postId) { (post) in
                if let postUrl = post.photoUrl {
                    self.postImageView.sd_setImage(with: URL(string: postUrl), completed: nil)
                }
            }
        default:
            print("")
        }
    }
    
    func setupUserInfo() {
        personPostedLabel.text = users?.username
        guard let profileImageUrl = users?.profileImageUrl else { return }
        profileImageView.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
        
    }
    
    func configureUI() {
        addSubview(profileImageView)
        profileImageView.centerY(inView: contentView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 8)
        addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor, paddingRight: 16)
        let stack = UIStackView(arrangedSubviews: [personPostedLabel, activityLabel])
        stack.axis = .vertical
        addSubview(stack)
        
        stack.anchor( top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingRight: 8)
        
    
    }
    
}

