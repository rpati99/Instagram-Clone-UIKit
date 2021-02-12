//
//  HelperService.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 05/02/21.
//

import Firebase

class HelperService {
    static let shared = HelperService()
    
    func uploadDataToServer(imageData: Data, videoUrl: URL? = nil ,caption: String, completion: @escaping() -> Void) {
        if let videoUrl = videoUrl {
          self.uploadVideo(videoUrl: videoUrl) { (videoURL) in
                self.uploadImage(imageData: imageData) { (thumbnailImgUrl) in
                    print("DBG: Thumbnail img url passed")
                    self.sendDataToDatabase(photoUrl: thumbnailImgUrl, videoUrl: videoURL, caption: caption, completion: completion)
                }
            }
        } else {
            self.uploadImage(imageData: imageData) { (photoUrl) in
                self.sendDataToDatabase(photoUrl: photoUrl, caption: caption, completion: completion)
            }
        }
        
    }
    
    func uploadVideo(videoUrl: URL, completion: @escaping(_ videoUrl: String) -> Void ) {
        let videoFilename = NSUUID().uuidString
        let storageRef = STORAGE_REF.child("post_images").child(videoFilename)
        
//        storageRef.putFile(from: videoUrl, metadata: nil) { (meta, error) in
//            if let error = error {
//                ProgressHUD.showError()
//                print("DBG: Error putting post in storage. \(error)")
//                return
//            }
//
//            storageRef.downloadURL { (url, error) in
//                if let videoUrl = url?.absoluteString {
//                    completion(videoUrl)
//                }
//            }
//        }
        guard let videoData = NSData(contentsOf: videoUrl) as Data? else { return }
        storageRef.putData(videoData, metadata: nil) { (meta , error) in
                        if let error = error {
                            ProgressHUD.showError()
                            print("DBG: Error putting post in storage. \(error)")
                            return
                        }
            
                        storageRef.downloadURL { (url, error) in
                            if let videoUrl = url?.absoluteString {
                                completion(videoUrl)
                            }
                        }
        }
    }
    
    func uploadImage(imageData: Data, completion: @escaping(_ photoUrl: String) -> Void) {
        let postFilename = NSUUID().uuidString
        let storageRef = STORAGE_REF.child("post_images").child(postFilename)
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            guard error == nil else { return }
            storageRef.downloadURL { (url, error) in
                guard  let postImageUrlString = url?.absoluteString else { return }
                completion(postImageUrlString)
            }
        }
    }
    
    

    func sendDataToDatabase(photoUrl: String, videoUrl: String? = nil ,caption: String, completion: @escaping() -> Void) {
        
        let postReference = DB_REF.child("posts")
        guard let newPostID = postReference.childByAutoId().key else { return }
        let newPostReference = postReference.child(newPostID)
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: .punctuationCharacters)
                HASHTAG_REF.child(word.lowercased()).updateChildValues([newPostID: true])
            }
        }
        
        let timestamp = Int(Date().timeIntervalSince1970)
       
        var value = ["photoUrl": photoUrl, "caption": caption, "userID": currentUserId, "timestamp": timestamp] as [String:  Any]
        
        if let videoUrl = videoUrl {
            value["videoUrl"] = videoUrl
            
        }
        
        newPostReference.setValue(value) { (error, ref) in
            if error != nil {
                ProgressHUD.showError()
                print("DBG: error uploading post data \(error!.localizedDescription)")
                return
            }
             
            
            REF_FEED.child(currentUserId).child(newPostID).setValue(true)
            
            REF_FOLLOWERS.child(currentUserId).observeSingleEvent(of: .value) { (snapshot) in
                let arraySnapshot = snapshot.children.allObjects as! [DataSnapshot]
                arraySnapshot.forEach { (child) in
                    REF_FEED.child(child.key).updateChildValues(["\(newPostID)": true])
                    let newNotifcationID = NOTIFICATION_REF.child(child.key).childByAutoId().key
                    let newNotificationReference = NOTIFICATION_REF.child(child.key).child(newNotifcationID!)
                    newNotificationReference.setValue(["from": currentUserId, "type": "feed", "objectId": newPostID])
                }
            }
            
            let myPostRef = MyPostService.shared.REF_POSTA.child(currentUserId).child(newPostID)
            myPostRef.setValue(true) { (error, ref) in
                if let error = error {
                    ProgressHUD.showError()
                    print("DBG: \(error.localizedDescription)")
                    return
                }
              
            }
            completion()
        }
    }
}
