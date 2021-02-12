//
//  Comment.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 27/01/21.
//

import Foundation
struct Comment {
    var commentText: String?
    var uid: String?
    
    static func transformComment(dict: [String: Any]) -> Comment {
        var comment = Comment()
        comment.commentText = dict["comment"] as? String ?? ""
        comment.uid = dict["userID"] as? String ?? ""
        return comment
    }
}
