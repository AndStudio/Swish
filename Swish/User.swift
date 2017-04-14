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
    private let userAvatarKey = "avatar_url"
    
    //properties for Users
    let userID: Int
    let userName: String
    let userUserName: String
    let userURL: URL
    let shotsURL: URL
    let likeCount: Int
    
    var userAvatar: UIImage?
    
    
    // memberwise initializer
    init(userID: Int, userName: String, userUserName: String, userURL: URL, shotsURL: URL, likeCount: Int, createdDate: Date, userAvatar: UIImage) {
        self.userID = userID
        self.userName = userName
        self.userUserName = userUserName
        self.userURL = userURL
        self.shotsURL = shotsURL
        self.likeCount = likeCount
        self.userAvatar = userAvatar
    
    }
    
    //failable initializer
    init?(dictionary: [String: Any]) {
        let userDictionary = dictionary["user"] as? [String: Any]
        
        guard let userID = userDictionary?[userIDKey] as? Int,
            let userName = userDictionary?[userNameKey] as? String,
            let userUserName = userDictionary?[userUserNameKey] as? String,
            let userURL = userDictionary?[userURLKey] as? URL,
            let shotsURL = userDictionary?[shotsURLKey] as? URL,
            let likeCount = userDictionary?[likeCountKey] as? Int,
            let userAvatar = userDictionary?[userAvatarKey] as? UIImage
            
            else { return nil }
        
        // initialize the failable/assign the values
        self.userID = userID
        self.userName = userName
        self.userUserName = userUserName
        self.userURL = userURL
        self.shotsURL = shotsURL
        self.likeCount = likeCount
        self.userAvatar = userAvatar
    }

    
}
