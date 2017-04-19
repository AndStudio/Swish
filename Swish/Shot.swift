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
    private let hiDpiImageKey = "hidpi"
    
    //MARK: - properties
    
    let shotID: Int
    let title: String
    let description: String?
    let viewCount: Int
    let likeCount: Int
    let createdDate: String
    let normalImageURL: String
    let teaserImageURL: String
    let hiDpiImageURL: String?
    
    var largeImage: UIImage?
    var teaserImage: UIImage?
    var user: User?
    
    
    //MARK: - failable initializer
    
    init?(dictionary: [String: Any]) {
        
        guard let shotID = dictionary[shotIDKey] as? Int,
            let title = dictionary[titleKey] as? String,
            let description = dictionary[descriptionKey] as? String,
            let viewCount = dictionary[viewCountKey] as? Int,
            let likeCount = dictionary[likeCountKey] as? Int,
            let createdDate = dictionary[createdDateKey] as? String,
            let imageDictionary = dictionary["images"] as? [String: Any],
            let normalImageURL = imageDictionary[normalImageKey] as? String,
            let teaserImageURL = imageDictionary[teaserImageKey] as? String
            else { return nil }
        
        self.shotID = shotID
        self.title = title
        self.description = Formatters.stripHTML(description as NSString)
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.createdDate = Formatters.formatDate(createdDate)
        self.normalImageURL = normalImageURL
        self.teaserImageURL = teaserImageURL
        self.hiDpiImageURL = imageDictionary[hiDpiImageKey] as? String
        
        if let userData = dictionary["user"] as? [String: Any] {
            self.user = User(dictionary: userData)
        }
    }
    
    init?(likeDictionary: [String:Any]) {
        guard let shotDictionary = likeDictionary["shot"] as? [String:Any],
            let shotID = shotDictionary[shotIDKey] as? Int,
            let title = shotDictionary[titleKey] as? String,
            let viewCount = shotDictionary[viewCountKey] as? Int,
            let likeCount = shotDictionary[likeCountKey] as? Int,
            let imageDictionary = shotDictionary["images"] as? [String: Any],
            let normalImageURL = imageDictionary[normalImageKey] as? String,
            let teaserImageURL = imageDictionary[teaserImageKey] as? String
            else { return nil }
        
        
            let unformattedDescription = shotDictionary[descriptionKey] as? NSString ?? ""
        guard let unformattedDate = shotDictionary[createdDateKey] as? String else { return nil }
        
        
        let formattedDescription = Formatters.stripHTML(unformattedDescription)
        let formattedDate = Formatters.formatDate(unformattedDate)
        
        self.shotID = shotID
        self.title = title
        self.description = formattedDescription
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.createdDate = formattedDate
        self.normalImageURL = normalImageURL
        self.teaserImageURL = teaserImageURL
        self.hiDpiImageURL = imageDictionary[hiDpiImageKey] as? String
        
        if let userData = shotDictionary["user"] as? [String: Any] {
            self.user = User(dictionary: userData)
        }
    }
}
