//
//  User.swift
//  Swish
//
//  Created by Clay Mills on 4/10/17.
//  Copyright © 2017 And. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    //properties keys
    private let userIDKey =  "id"
    private let userNameKey =  "name"
    private let userUserNameKey =  "username"
    private let userURLKey =  "html_url"
    private let shotsURLKey = "shots_url"
    private let likeCountKey =  "likes_count"
    private let userAvatarURLKey = "avatar_url"
    private let shotsCountKey = "shots_count"
    
    //properties for Users
    var userID: Int
    var userName: String
    var userUserName: String
    var userAvatarURL: String
    var shotsURL: String
    var likeCount: Int
    var shotsCount: Int
    
    var userAvatar: UIImage?
    
    //failable initializer
    init?(dictionary: [String: Any]) {
        
        guard let userID = dictionary[userIDKey] as? Int,
            let userName = dictionary[userNameKey] as? String,
            let userUserName = dictionary[userUserNameKey] as? String,
            let userAvatarURL = dictionary[userAvatarURLKey] as? String,
            let shotsURL = dictionary[shotsURLKey] as? String,
            let likeCount = dictionary[likeCountKey] as? Int,
            let shotsCount = dictionary[shotsCountKey] as? Int
            else { return nil }
        
        // initialize the failable/assign the values
        self.userID = userID
        self.userName = userName
        self.userUserName = userUserName
        self.userAvatarURL = userAvatarURL
        self.shotsURL = shotsURL
        self.likeCount = likeCount
        self.shotsCount = shotsCount 
        
    }

    
}
