//
//  User.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 27/01/21.
//

import UIKit

class User {
    
    var email: String?
    var username: String?
    var profileImageUrl: String?
    var id: String?
    var isFollowing: Bool?
    
    static func transformUser(dict: [String: Any], key: String) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.username = dict["username"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.id = key
        return user 
    }
}

