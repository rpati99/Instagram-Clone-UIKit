//
//  CommentService.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 28/01/21.
//

import Firebase

class CommentService {
    static let shared = CommentService()
    
    func observeComments(postID: String, completion: @escaping(String, Comment) -> Void) {
        let postCommentRef = DB_REF.child("post-comments").child(postID)
        postCommentRef.observe(.childAdded) { (snapshot) in
            DB_REF.child("comments").child(snapshot.key).observeSingleEvent(of: .value) { (snapshotComment) in
                guard let dict = snapshotComment.value as? [String: Any] else { return }
                let newComment = Comment.transformComment(dict: dict)
                guard let uid = newComment.uid else { return }
                completion(uid, newComment)
            }
        }
    }
}
