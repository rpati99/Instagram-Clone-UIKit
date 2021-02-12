//
//  ProfilePostCell.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 29/01/21.
//

import UIKit

class ProfilePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateView() {
        guard let postURL = post?.photoUrl else { return }
        postImageView.sd_setImage(with: URL(string: postURL), completed: nil)
    }
    
    func setupUI() {
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
    }
    
    
    
}
