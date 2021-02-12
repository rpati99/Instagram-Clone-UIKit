//
//  CustomCell.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit
import SDWebImage
import Firebase
import AVFoundation
import KILabel

protocol  PostCellDelegate {
    func goToHashtag(tag: String)
}

class PostCell: UICollectionViewCell {
    
     //MARK: - Properties
    
    var homeVC: HomeViewController?
    var postRef: DatabaseReference!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var delegate: PostCellDelegate?
    
    
    var posts: Post? {
        didSet {
            guard let caption = posts?.captionText else { return }
            guard let imageUrl = posts?.photoUrl else { return }
            
            if let videoString = posts?.videoUrl, let videoUrl = URL(string: videoString) {
                player = AVPlayer(url: videoUrl)
                playerLayer = AVPlayerLayer(player: player)
                postImageView.layer.addSublayer(playerLayer!)
                playerLayer?.frame = postImageView.bounds
                player?.play()
                
            }
            
            if let timestamp = posts?.timestamp {
                let timeStampDate = Date(timeIntervalSince1970: Double(timestamp))
                let now  = Date()
                let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
                let diff = Calendar.current.dateComponents(components, from: timeStampDate, to: now)
                
                var timeText = ""
                
                switch diff {
                case let diff where diff.second! <= 0 :
                    timeText = "Just now"
                case let diff where diff.second! > 0 && diff.minute! == 0:
                    timeText = diff.second == 1 ? "\(diff.second!) second ago": "\(diff.second!) seconds ago"
                case let diff where  diff.minute! > 0 && diff.hour! == 0:
                    timeText = diff.minute == 1 ? "\(diff.minute!) minute ago": "\(diff.minute!) minutes ago"
                case let diff where diff.hour! > 0 && diff.day! == 0:
                    timeText = diff.hour == 1 ? "\(diff.hour!) hour ago": "\(diff.hour!) hours ago"
                case let diff where diff.day! > 0 && diff.weekOfMonth! == 0:
                    timeText = diff.day == 1 ? "\(diff.hour!) day ago": "\(diff.hour!) days ago"
                case let diff where diff.weekOfMonth! > 0:
                    timeText = diff.weekOfMonth == 1 ? "\(diff.weekOfMonth!) month ago": "\(diff.weekOfMonth!) months ago"
                  default:
                       timeText = ""
                }
                

                
                
                
                timeStampLabel.text = timeText
            }
            
            captionLabel.text = caption
        
            captionLabel.hashtagLinkTapHandler = { label, string, range in
                let tag = String(string.dropFirst())
                self.delegate?.goToHashtag(tag: tag)
                
            }
            postImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
       
            self.updateLike(post: self.posts!)


        }
    }
    
    var users: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    private let personPostedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView().createProfileImageView(width: 30, height: 30)
        return iv
    }()
    
    private let captionLabel: KILabel = {
        let label = KILabel()
        label.textColor = .black
        label.numberOfLines = 0
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return label
    }()
    
    private let timeStampLabel: UILabel = {
        let label = UILabel().topLabel(title: "", weight: .light)
        label.tintColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton().createActionButton(image: UIImage(named: "like"))
         return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton().createActionButton(image: UIImage(named: "message"))
        
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton().createActionButton(image: UIImage(named: "share"))
        return button
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        label.text = "Be the first to like this"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    
     //MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        timeStampLabel.text = ""
    }
    
     //MARK: - selector functions
    
    @objc func handleLike() {
      print("DBG: Handle like")
        guard let postID = posts?.id else { return }
        postRef =  POST_REF.child(postID)
        incrementLikes(forRef: postRef)
        updateLike(post: posts!)

        
    }
 
    @objc func handleComment() {
        print("DBG: Handle Comment")
        guard let id = posts?.id else { return }
        let commentVC = CommentViewController(collectionViewLayout: UICollectionViewFlowLayout())
        commentVC.postID = id
        homeVC?.navigationController?.pushViewController(commentVC, animated: true)
        
    }
    
    
    @objc func handleShare() {
        print("DBG: Handle Share")
    }
    
   //MARK: - API
    func incrementLikes(forRef ref: DatabaseReference) {
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
          if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
     
            var likes: Dictionary<String, Bool>
            likes = post["likes"] as? [String : Bool] ?? [:]
            var likeCount = post["likeCount"] as? Int ?? 0
            if let _ = likes[uid] {
              // Unstar the post and remove self from stars
              likeCount -= 1
              likes.removeValue(forKey: uid)
            } else {
              // Star the post and add self to stars
              likeCount += 1
              likes[uid] = true
            }
            post["likeCount"] = likeCount as AnyObject?
            post["likes"] = likes as AnyObject?

            // Set value and report transaction success
            currentData.value = post

            return TransactionResult.success(withValue: currentData)
          }
          return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
          if let error = error {
            print(error.localizedDescription)
          }
            guard let dict = snapshot?.value as? [String: Any] else { return }
            var post = Post.transformPostPhoto(dictionary: dict, key: snapshot!.key)
            self.updateLike(post: post)
            post.likes = self.posts?.likes
            post.isLiked = self.posts?.isLiked
            post.likeCount = self.posts?.likeCount
        }
    }
    
    func updateLike(post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "like_selected"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
        guard let count = post.likeCount else {
            return
        }
        
        if   count != 0 {
            amountLabel.text = "\(count) likes"
        } else  {
            amountLabel.text = "Be the first to like this"
        }
    }
    
     //MARK: - Helper functions
    private func setupUserInfo() {
        personPostedLabel.text = users?.username
        guard let profileImageUrl = users?.profileImageUrl else { return }
        profileImageView.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
    }

    private func setupUI() {

        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 8)
        addSubview(personPostedLabel)
        personPostedLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 14, paddingLeft: 8, paddingRight: 8)
        addSubview(seperatorView)
        seperatorView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8 ,height: 0.5)
        addSubview(postImageView)
        postImageView.anchor(top: seperatorView.bottomAnchor,left: leftAnchor, right: rightAnchor, height: 320)
        addSubview(likeButton)
        likeButton.anchor(top: postImageView.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 10)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)

        addSubview(commentButton)
        commentButton.anchor(top: postImageView.bottomAnchor, left: likeButton.rightAnchor, paddingTop: 8, paddingLeft: 8)
        commentButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        
        addSubview(shareButton)
        shareButton.anchor(top: postImageView.bottomAnchor, left: commentButton.rightAnchor, paddingTop: 8, paddingLeft: 8)
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        addSubview(amountLabel)
        amountLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 10)
        addSubview(timeStampLabel)
        timeStampLabel.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 8, paddingBottom: 2)
        addSubview(captionLabel)
        captionLabel.anchor(top: amountLabel.bottomAnchor, left: leftAnchor,bottom: timeStampLabel.topAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingRight: 8)
        
    }
    

}
