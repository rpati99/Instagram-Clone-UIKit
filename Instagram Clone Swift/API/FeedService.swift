//
//  FeedService.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 31/01/21.
//

import Firebase

class FeedService {
    static let shared = FeedService()
    
    func observeFeed(withId id: String, completion: @escaping(Post) -> Void) {
        REF_FEED.child(id).observe(.childAdded) { (snapshot) in
            PostService.shared.observePost(withID: snapshot.key, completion: completion)
        }
    }
    
    func observeFeedRemoved(userID id: String, completion: @escaping(Post) -> Void) {
        REF_FEED.child(id).observe(.childRemoved) { (snapshot) in
            let key = snapshot.key //post key instead of object
            PostService.shared.observePost(withID: key) { (post) in
                completion(post)
            }
        }
    }
    
    
    
}
