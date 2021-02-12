//
//  CommentViewControllrt.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 27/01/21.
//

import UIKit
import Firebase

// MARK: - TODO URL

class CommentViewController : UICollectionViewController {
    
    //MARK: - Elements
    var postID: String?
    var comments = [Comment]()
    var users = [User]() //real time loads
    var bottomConstraint: NSLayoutConstraint?
    
    private let commentTextField: UITextField = {
        let tv = UITextField().createTextField(placeholder: "Comment", isSecureTextEntry: false)
        return tv
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.setDimensions(width: 60, height: 30)
        button.addTarget(self, action: #selector(sendCommentToDatabase), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(sendButton)
        sendButton.centerY(inView: view)
        sendButton.anchor(right: view.rightAnchor, paddingRight: 8)
        view.addSubview(commentTextField)
        commentTextField.centerY(inView: view)
        commentTextField.anchor( left: view.leftAnchor, right: sendButton.leftAnchor,paddingLeft: 16)
        return view
    }()
    

    
    //MARK: - Application lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleTextField()
        loadComments()

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.navigationItem.title = "Comments"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Selector functions
    @objc func handleKeyboardShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            let value = notification.name ==  UIResponder.keyboardWillShowNotification ? -keyboardFrame!.height : 0
            self.view.frame.origin.y = value
        }
    }
    

    @objc func sendCommentToDatabase() {

        let commentReference = DB_REF.child("comments")
        
        guard let newCommentID = commentReference.childByAutoId().key else { return }
        let newCommentReference = commentReference.child(newCommentID)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let comment = commentTextField.text else { return }
        let currentUserId = currentUser.uid
        let value = ["comment": comment, "userID": currentUserId]
        
        newCommentReference.setValue(value) { (error, ref) in
            if error != nil {
                ProgressHUD.showError()
                print("DBG: error uploading post data \(error!.localizedDescription)")
                return
            }
            
        
            guard let postID = self.postID else { return }
            let words = comment.components(separatedBy: .whitespacesAndNewlines)
            for var word in words {
                if word.hasPrefix("#") {
                    word = word.trimmingCharacters(in: .punctuationCharacters)
                    HASHTAG_REF.child(word.lowercased()).updateChildValues([postID: true])
                }
            }

            let postCommentRef = DB_REF.child("post-comments").child(postID).child(newCommentID)
            postCommentRef.setValue(true) { (error, ref) in
                if error != nil {
                    ProgressHUD.showError()
                    return
                }
            }
            self.empty()
        }
    }
    
    @objc func textFieldDidChange() {
        let value =  commentTextField.text!.isEmpty ? true : false
        guard value == true else {
            sendButton.isHidden = false
            return
        }
    }
    
    //MARK: - API
    
    
    func loadComments() {
        guard let postID = postID else { return }
        CommentService.shared.observeComments(postID: postID) { (uid, newComment)  in
            self.fetchUser(uid: uid) {
                self.comments.append(newComment)
                self.collectionView.reloadData()
            }
        }

    }
    
    func fetchUser(uid: String, _ completed: @escaping () -> Void)  {
          REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = User.transformUser(dict: dict, key: snapshot.key)
            self.users.append(user)
            completed()
        }
    }

    
     //MARK: - HELPERS
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    func empty() {
        self.commentTextField.text = ""
        self.sendButton.isHidden = true
    }
    
    func setupUI() {
        self.collectionView.register(CommentCell.self, forCellWithReuseIdentifier: commentCellID)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .white
        self.collectionView.showsVerticalScrollIndicator = false
        view.addSubview(commentView)
        commentView.backgroundColor = .red
        commentView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 0, height: 60)
     
        
    }
}

 //MARK: - CollectionView delegate

extension CommentViewController : UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellID, for: indexPath)
        as! CommentCell
        cell.comments = comments[indexPath.row]
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let controller = UserViewController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.userId = users[indexPath.item].id!
           navigationController?.pushViewController(controller, animated: true)

    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}


extension CommentViewController: CommentCellDelegate {
    func goToHashtag(tag: String) {
        let hashtagVC = HashtagViewController(collectionViewLayout: UICollectionViewFlowLayout())
        hashtagVC.hashtag = tag.lowercased()
        self.navigationController?.pushViewController(hashtagVC, animated: true)
        
    }
    
    
}
