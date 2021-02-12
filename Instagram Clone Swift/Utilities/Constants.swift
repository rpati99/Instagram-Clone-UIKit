//
//  Constants.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 28/01/21.
//


import Firebase

let postCellID = "cellID"
let commentCellID = "commentCellID"
let profileCellID = "profileCellID"
let profileHeaderID = "profileHeaderID"
let headerElementKind = "headerElementKind"
let usersCellID = "usersCellID"
let discoverCellID = "discoverCellID"
let userProfileHeaderCellID = "userProfileHeaderCellID"
let userProfilePostCellID = "userProfilePostCellID"
let settingsCellID = "settingsCellID"
let choosePostPhotoCellID = "choosePostPhotoCellID"
let hashtagPostID = "hashtagPostID"
let activityCellID = "activityCellID"



let DB_REF = Database.database(url: "https://instagram-zero2launch-default-rtdb.firebaseio.com/").reference()
let REF_USERS = DB_REF.child("users")


let STORAGE_REF =  Storage.storage().reference()
let SREF_PRFIMG = STORAGE_REF.child("profile_images")

let POST_REF =  DB_REF.child("posts")
let REF_FOLLOWERS = DB_REF.child("Followers")
let REF_FOLLOWING = DB_REF.child("Following")

let REF_FEED = DB_REF.child("Feed")
let HASHTAG_REF = DB_REF.child("hashtags")

let NOTIFICATION_REF = DB_REF.child("notification")
