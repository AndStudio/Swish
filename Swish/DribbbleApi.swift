//
//  DribbbleApi.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/11/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class DribbleApi {

    static let clientID = "7e3ecb0581a0c7346f00029b96826f0267e92ec0a16759eeefaeafec841ff762"
    static let clientSecret = "8a8fad391aff41852cd8dd52d7f54f97e050014d3bfa1682538cd8ade9243be8"
    static let clientAccessKey = "a1590f48ee53ae2d172f3c49a444ce3d658e92cf7c95a91cc39eebbd4c5197cd"
    static let scope = "public+write"
    
    static let swipeShotsToLoad = 10
    static let collectionShotsToLoad = 20
    
    static var currentUser: User?
    
    static var apiResetDate: NSDate?
    static var apiCurrentLimit: Int = 60 {
        didSet {
            NSLog("Current API limit: \(apiCurrentLimit)")
            if apiCurrentLimit <= 1 {
                NotificationCenter.default.post(name: presentAPIAlertControllerNotification, object: self)
            }
        }
    }
    
    // MARK: API Response Header Tracking Functions
    
    static func updateAPIHeaderResponses(headerDictionary: URLResponse) {
        let httpURLResponseFromHeader = headerDictionary as? HTTPURLResponse
        let responseHeaderDictionary = httpURLResponseFromHeader?.allHeaderFields
        
        guard
            let timeIntervalString = responseHeaderDictionary?["x-ratelimit-reset"] as? String,
            let timeInterval = Double(timeIntervalString),
            let apiLimitString = responseHeaderDictionary?["x-ratelimit-limit"] as? String,
            let apiLimit = Int(apiLimitString)
            else { return }
        
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        DribbleApi.apiResetDate = date
        DribbleApi.apiCurrentLimit = apiLimit
        
    }
    
    // MARK: Alert Controller for API limit
    
    static func presentAPIInfoAlertController(view: UIViewController) {
        let currentTimeStamp = Date()
        guard let resetDate = apiResetDate as Date? else { return }
        let timeDifferenceInSeconds = currentTimeStamp.timeIntervalSince(resetDate)
        
        let alertController = UIAlertController(title: "Dribbble Limit Reached", message: "The Dribbble API only allows a certain amount of access per user. You can do more in \(timeDifferenceInSeconds) seconds", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel) { (_) in }
        
        alertController.addAction(dismissAction)
        
        view.present(alertController, animated: true)
    }
}
