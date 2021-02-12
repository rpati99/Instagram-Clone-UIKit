//
//  Notifications=.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 11/02/21.
//

import Firebase

struct Notifications {
    var from: String?
    var objectId: String?
    var type: String?
    var id: String?
    
    static func transform(dictionary: [String: Any], key: String) -> Notifications {
        var notification = Notifications()
        notification.id = key
        notification.objectId = dictionary["objectId"] as? String
        notification.type = dictionary["type"] as? String
        notification.from = dictionary["from"] as? String  
        return notification
    }


}
