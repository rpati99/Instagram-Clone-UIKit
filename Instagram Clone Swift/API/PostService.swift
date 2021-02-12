//
//  PostService.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 28/01/21.
//

import Firebase

class PostService {
    static let shared = PostService()
    
    func observePosts(uid: String, completion: @escaping(Post, String) -> Void) {
        
//        DB_REF.child("Feed").child(uid).observeSingleEvent(of: .value) { (snapshot) in
//            guard let dict = snapshot.value as? [String: Any] else { return }
//            print("DBG: \(dict.keys)")
//        }
        
        POST_REF.observe(.childAdded) { (snapShot) in
            guard let dict = snapShot.value as? [String: Any] else { return }
            let post = Post.transformPostPhoto(dictionary: dict, key: snapShot.key)
            guard let uid = post.uid else { return }
            completion(post, uid)
        }
    }
    
    func observePost(withID id: String, completion: @escaping(Post) -> Void) {
        POST_REF.child(id).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(dictionary: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
    
    func observeTopPosts(completion: @escaping(Post) -> Void) {
        POST_REF.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value) { (snapshot) in
            let arraySnapShot = snapshot.children.allObjects as! [DataSnapshot]
            for child in arraySnapShot.reversed() {
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dictionary: dict, key: snapshot.key)
                    completion(post)
                }
            }
        }
    }

}
