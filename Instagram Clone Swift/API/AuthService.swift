//
//  AuthService.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 28/01/21.
//

import UIKit
import Firebase

struct AuthCredentials {
    var email: String
    var password: String
    var username: String
    var username_lowercased: String 
    var profileImage: UIImage
}

class AuthService {
    static let shared = AuthService()
    
    func loginUser(email: String, password: String, completion: @escaping() -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                ProgressHUD.showError()
                print("DBG: Failed to login \(error.localizedDescription)")
                return
            }
            completion()
        }
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = credentials.email
        let username = credentials.username
        let password = credentials.password
        let profileImage = credentials.profileImage
        let usernameLowercase = credentials.username_lowercased
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return  }
        let filename = NSUUID().uuidString
        //Uploading profile image
        let storageRef = SREF_PRFIMG.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            //uploading url
            ProgressHUD.show("Waiting...", interaction: false)
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                //Sign up user
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        ProgressHUD.showError()
                        print("DBG: error registering user \(error.localizedDescription)")
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    let values = ["email": email, "username": username, "username_lowercase": usernameLowercase,
                                  "profileImageUrl": profileImageUrl]
                   //uploading data to database
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                    }
                }
            }
        }
    
    
    func signOut(completion: @escaping() -> ()) {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print("DBG: Error signing out \(err)")
        }
        completion()
    }

}
