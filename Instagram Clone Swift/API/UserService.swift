//
//  UserService.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 29/01/21.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func observeCurrentUser(withID id: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(id).observeSingleEvent(of: .value, with: { (snapShot) in
            guard let dict = snapShot.value as? [String: Any] else { return }
            let user = User.transformUser(dict: dict, key: snapShot.key)
            completion(user)
        })
    }
    
    func observeCurrentUser(completion: @escaping(User) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapShot) in
            guard let dict = snapShot.value as? [String: Any] else { return }
            let user = User.transformUser(dict: dict, key: snapShot.key)
            completion(user)
        })
    }
    
    func queryUsers(withText text: String, completion: @escaping(User) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value) { (snapshot) in
            //snapshot.children . pointer to iterate snapshot array
            snapshot.children.forEach { (s) in
                let child = s as! DataSnapshot
                guard let dict = child.value as? [String: Any] else { return }
                let user = User.transformUser(dict: dict, key: child.key)
                completion(user)
            }
        }
    }
}

