//
//  Shot.swift
//  Swish
//
//  Created by Taylor Phillips on 4/10/17.
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
    private let imageURLKey =  "html_url"
    private let tagsKey =  "tags"
    private let commentURLKey = "comments_url"
    private let commentCountKey = "comments_count"
    
    
    //MARK: - properties
    
    let shotID: Int
    let title: String
    let description: String
    let viewCount: Int
    let likeCount: Int
    let createdDate: Date
    let imageURL: String
    let tags: [String]
    let commentURL: String
    let commentCount: Int
    
    var imageData: Data?
    
//    var user: User?
    
    
    // FIXME: - set up image properties
    
    //    let shotImageURLString: String
    //    var shotImage: UIImage?
    //    var shotImageURL: URL? {
    //        return URL(string: shotImageURLString)
    //    }
   
    //MARK: - failable initializer
    
    init?(dictionary: NSDictionary) {
        
        
        
        guard let shotID = dictionary[shotIDKey] as? Int,
            let title = dictionary[titleKey] as? String,
            let description = dictionary[descriptionKey] as? String,
            let viewCount = dictionary[viewCountKey] as? Int,
            let likeCount = dictionary[likeCountKey] as? Int,
            let createdDate = dictionary[createdDateKey] as? Date,
            let imageURL = dictionary[imageURLKey] as? String,
            let tags = dictionary[tagsKey] as? [String],
            let commentURL = dictionary[commentURLKey] as? String,
            let commentCount = dictionary[commentCountKey] as? Int
                else { return nil }
        
        self.shotID = shotID
        self.title = title
        self.description = description
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.createdDate = createdDate
        self.imageURL = imageURL
        self.tags = tags
        self.commentURL = commentURL
        self.commentCount = commentCount
        
    }
}
