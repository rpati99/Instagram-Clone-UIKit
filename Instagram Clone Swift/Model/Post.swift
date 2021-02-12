//
//  Post.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit
import Firebase

struct Post {
    var photoUrl: String?
    var captionText: String?
    var videoUrl: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    var timestamp: Int?
    
    
    static func transformPostPhoto(dictionary: [String: Any], key: String) -> Post {
        var post = Post()
        post.uid = dictionary["userID"] as? String
        post.photoUrl = dictionary["photoUrl"] as? String
        post.videoUrl = dictionary["videoUrl"] as? String
        post.captionText = dictionary["caption"] as? String
        post.id = key
        post.likeCount =  dictionary["likeCount"] as? Int
        post.likes = dictionary["likes"] as? Dictionary<String, Any>
        post.timestamp = dictionary["timestamp"] as? Int  
         if post.likes != nil  {
            if let currentUserId = Auth.auth().currentUser?.uid {
                post.isLiked = post.likes![currentUserId] != nil
        }
    }

        return post
    }

    
}
