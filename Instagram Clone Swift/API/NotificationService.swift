//
//  NotificationService.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 11/02/21.
//

import Firebase

struct NotificationService  {
   
    static func observeNotification(withId id: String, completion: @escaping(Notifications) -> Void) {
        NOTIFICATION_REF.child(id).observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let newNotification = Notifications.transform(dictionary: dict, key: snapshot.key)
            completion(newNotification)
        }
    }
}
