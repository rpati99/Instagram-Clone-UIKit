//
//  CommentCell.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 27/01/21.
//

import UIKit
import KILabel

protocol  CommentCellDelegate {
    func goToHashtag(tag: String)
}

class CommentCell: UICollectionViewCell {
    
    var delegate: CommentCellDelegate?
    
    
    var comments: Comment? {
        didSet {
            guard let comment = comments?.commentText else { return }
            commentLabel.text = comment
            commentLabel.hashtagLinkTapHandler  = { label, string, range in
                    let tag = String(string.dropFirst())
                    self.delegate?.goToHashtag(tag: tag)
            }
        }
    }
    
    var user: User? {
        didSet {
            guard let userName = user?.username else { return }
            guard let profileImageUrl = user?.profileImageUrl else { return }
            personPostedLabel.text = userName
            profileImageView.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView().createProfileImageView(width: 35, height: 35)
        return iv
    }()
    
    private let personPostedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "djnksjdvb dkbsk"
        return label
    }()
    
    private let commentLabel: KILabel = {
        let label = KILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "djnksjdvb dkbsk"
        return label
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        personPostedLabel.text = ""
        commentLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.backgroundColor = .gray
    }
    
    func setupUI() {
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10,paddingLeft: 8)
        let stack = UIStackView(arrangedSubviews: [personPostedLabel, commentLabel])
        stack.axis = .vertical
        addSubview(stack)
        
        stack.anchor( top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingRight: 8)
        let seperatorView = UIView()
        seperatorView.backgroundColor = .gray
        addSubview(seperatorView)
        seperatorView.anchor( left: leftAnchor, bottom: bottomAnchor, right: rightAnchor ,height: 0.5)
    }
    
    
  
    

}
