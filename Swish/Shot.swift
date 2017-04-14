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
    private let normalImageKey =  "normal"
    private let teaserImageKey = "teaser"
    private let tagsKey =  "tags"
    
    //MARK: - properties
    
    let shotID: Int
    let title: String
    let description: String
    let viewCount: Int
    let likeCount: Int
    let createdDate: String
    let tags: [String]
    let normalImageURL: String
    let teaserImageURL: String
    
    var normalImage: UIImage?
    var teaserImage: UIImage?
    var user: User?
    
    
    
    //MARK: - failable initializer
    
    init?(dictionary: [String: Any]) {
        
        guard let shotDictionary = dictionary["shot"] as? [String:Any],
            let shotID = shotDictionary[shotIDKey] as? Int,
            let title = shotDictionary[titleKey] as? String,
            let description = shotDictionary[descriptionKey] as? String,
            let viewCount = shotDictionary[viewCountKey] as? Int,
            let likeCount = shotDictionary[likeCountKey] as? Int,
            let createdDate = shotDictionary[createdDateKey] as? String,
            let tags = shotDictionary[tagsKey] as? [String],
            let imageDictionary = shotDictionary["images"] as? [String: Any],
            let normalImageURL = imageDictionary[normalImageKey] as? String,
            let teaserImageURL = imageDictionary[teaserImageKey] as? String
        
            else { return nil }
        
        self.shotID = shotID
        self.title = title
        self.description = description
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.createdDate = createdDate
        self.tags = tags
        self.normalImageURL = normalImageURL
        self.teaserImageURL = teaserImageURL
        
        if let userData = dictionary["user"] as? [String: Any] {
            self.user = User(dictionary: userData)
        }
    }
}
