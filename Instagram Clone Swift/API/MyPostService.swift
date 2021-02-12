//
//  MyPostService.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 29/01/21.
//

import Firebase

struct MyPostService {
    static let shared = MyPostService()
    
    var REF_POSTA = DB_REF.child("myPosts")
    
}
