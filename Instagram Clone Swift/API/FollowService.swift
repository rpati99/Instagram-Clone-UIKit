//
//  FollowServicr.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 30/01/21.
//

import Firebase

struct FollowService {

    static let shared = FollowService()

    func handleFollow(userID: String, currentUserID: String) {
    
        MyPostService.shared.REF_POSTA.child(userID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            dict.keys.forEach( { REF_FEED.child(currentUserID).child($0).setValue(true) })
        }
        
        REF_FOLLOWING.child(currentUserID).child(userID).setValue(true) { (error, ref) in
            if let error = error {
                ProgressHUD.showError()
                print("DBG: Failed to unfollow user \(error.localizedDescription)")
                return
            }
            
            print("DBG: Success followING")
            
        }
        
        REF_FOLLOWERS.child(userID).child(currentUserID).setValue(true) { (error, ref) in
            if let error = error {
                ProgressHUD.showError()
                print("DBG: Failed to follow user \(error.localizedDescription)")
                return
            }
            print("DBG: Success follower")
            
        }
    }
    
    func handleUnfollow(userID: String, currentUserID: String) {
        
        MyPostService.shared.REF_POSTA.child(userID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            dict.keys.forEach( { REF_FEED.child(currentUserID).child($0).removeValue() })
        }

        REF_FOLLOWERS.child(userID).child(currentUserID).setValue(NSNull())
        REF_FOLLOWING.child(currentUserID).child(userID).setValue(NSNull())
    }
    
    
    func isFollowingUser(userId: String, currentUserID: String, completion: @escaping(Bool) -> Void)  {
        REF_FOLLOWERS.child(userId).child(currentUserID).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func fetchFollowingCount(userID: String, completion: @escaping(Int) -> Void) {
        REF_FOLLOWING.child(userID).observe(.value) { (snapshot) in
            let count = Int(snapshot.childrenCount)
            completion(count)
        }
    }
    
    func fetchFollowersCount(userID: String, completion: @escaping(Int) -> Void) {
        REF_FOLLOWERS.child(userID).observe(.value) { (snapshot) in
            let count = Int(snapshot.childrenCount)
            completion(count)
        }
    }

}
