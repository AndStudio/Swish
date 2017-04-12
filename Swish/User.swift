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
    
    //MARK: - properties keys
    
    private let shotIDKey =  "id"
    private let titleKey =  "title"
    private let descriptionKey =  "description"
    private let viewCountKey =  "views_count"
    private let likeCountKey =  "likes_count"
    private let createdDateKey =  "created_at"
    private let imageLinkURLKey =  "html_url"
    private let tagsKey =  "tags"
    
    private let userIDKey =  "id"
    private let userNameKey =  "name"
    private let userUserNameKey =  "username"
    private let userURLKey =  ""
    
    
    //MARK: - properties
    
    //MARK: - id, title, description,  image - normal + teaser, views count, likes count, comments count, creation date, tags, comments url, likes url, user id, user real name, user user name, user URL, user avatar
    let shotID: Int
    let title: String
    let description: String
    let viewCount: Int
    let likeCount: Int
    let createdDate: Date
    let imageLinkURL: URL
    let tags: [String]
    
    let userID: Int
    let userName: String
    let userUserName: String
    let userURL: URL
    
    
    // FIXME: - set up image properties
    
    //    let shotImageURLString: String
    //    var shotImage: UIImage?
    //    var shotImageURL: URL? {
    //        return URL(string: shotImageURLString)
    //    }
    //
    //    let userAvatarURLString: String
    //    var userAvatar: UIImage?
    //    var userAvatarURL: URL? {
    //        return URL(string: userAvatarURLString)
    //    }
    
    //MARK: - memberwise initializer
    init(shotID: Int, title: String, description: String, viewCount: Int, likeCount: Int, createdDate: Date, imageLinkURL: URL, tags: [String], userID: Int, userName: String, userUserName: String, userURL: URL) {
        self.shotID = shotID
        self.title = title
        self.description = description
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.createdDate = createdDate
        self.imageLinkURL = imageLinkURL
        self.tags = tags
        self.userID = userID
        self.userName = userName
        self.userUserName = userUserName
        self.userURL = userURL
        
    }
    
    //MARK: - failable initializer
    
    init?(dictionary: [String: Any]) {
        
        let userDictionary = dictionary["user"] as? [String: Any]
        
        guard let shotID = dictionary[shotIDKey] as? Int,
            let title = dictionary[titleKey] as? String,
            let description = dictionary[descriptionKey] as? String,
            let viewCount = dictionary[viewCountKey] as? Int,
            let likeCount = dictionary[likeCountKey] as? Int,
            let createdDate = dictionary[createdDateKey] as? Date,
            let imageLinkURL = dictionary[imageLinkURLKey] as? URL,
            let tags = dictionary[tagsKey] as? [String],
            let userID = userDictionary?[userIDKey] as? Int,
            
            let userName = userDictionary?[userNameKey] as? String,
            let userUserName = userDictionary?[userUserNameKey] as? String,
            let userURL = userDictionary?[userURLKey] as? URL
            else { return nil }
        
        self.shotID = shotID
        self.title = title
        self.description = description
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.createdDate = createdDate
        self.imageLinkURL = imageLinkURL
        self.tags = tags
        self.userID = userID
        self.userName = userName
        self.userUserName = userUserName
        self.userURL = userURL
    }

    
}
