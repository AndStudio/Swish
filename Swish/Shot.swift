//
//  Shot.swift
//  Swish
//
//  Created by Taylor Phillips on 4/12/17.
//  Copyright © 2017 And. All rights reserved.
//

import Foundation
import UIKit

class Shot {
    
    //MARK: - properties keys
    
    private let shotIDKey =  "id"
    private let titleKey =  "title"
    private let descriptionKey =  "description"
    private let viewCountKey =  "views_count"
    private let likeCountKey =  "likes_count"
    private let createdDateKey =  "created_at"
    private let imageKey =  "normal"
    private let tagsKey =  "tags"
    
    //MARK: - properties
    
    let shotID: Int
    let title: String
    let description: String
    let viewCount: Int
    let likeCount: Int
    let createdDate: String
    let tags: [String]
    let imageURL: String
    
    var image: UIImage?
//    var user: User?
    
    //MARK: - failable initializer
    
    init?(dictionary: [String: Any]) {
        
        guard let shotID = dictionary[shotIDKey] as? Int,
            let title = dictionary[titleKey] as? String,
            let description = dictionary[descriptionKey] as? String,
            let viewCount = dictionary[viewCountKey] as? Int,
            let likeCount = dictionary[likeCountKey] as? Int,
            let createdDate = dictionary[createdDateKey] as? String,
            let tags = dictionary[tagsKey] as? [String],
            let imageDictionary = dictionary["images"] as? [String: Any],
            let imageURL = imageDictionary[imageKey] as? String
            
            else { return nil }
        
        self.shotID = shotID
        self.title = title
        self.description = description
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.createdDate = createdDate
        self.tags = tags
        self.imageURL = imageURL
        
//        if let userData = dictionary["user"] as? [String: Any] {
//            self.user = User(data: userData)
//        }
        
    }
    
}
