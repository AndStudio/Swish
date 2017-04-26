//
//  DribbbleApi.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/11/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class DribbleApi {
    
    // MARK: Switch Dribble accounts enum
    
    enum dribbleAPIKeys {
        case clay
        case david
        case andrew
        case taylor
    }
    
    static var clientID = "e97282047496bac5ee671f3dd82e7e44789a3a011f10d1c8ba375aab4f93097f"
    static var clientSecret = "58770dac962283bdbd486ae4815d087654731bec8d3753a9e332c3069ebd5e8d"
    static var clientAccessKey = "70a3dded364357c7f618fd1eb28241ac19511cd0f2110ed34b8508d7e3217184"
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
            let apiLimitString = responseHeaderDictionary?["x-ratelimit-remaining"] as? String,
            let apiLimit = Int(apiLimitString)
            else { return }
        
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        DribbleApi.apiResetDate = date
        DribbleApi.apiCurrentLimit = apiLimit
        
    }
    
    // MARK: Alert Controller for notfications/observers
    
    static func presentAPIInfoAlertController(view: UIViewController) {
        let currentTimeStamp = Date()
        guard let resetDate = apiResetDate as Date? else { return }
        let timeDifferenceInSeconds = Int(ceil(currentTimeStamp.timeIntervalSince(resetDate)))
        
        let alertController = UIAlertController(title: "Dribbble Limit Reached", message: "The Dribbble API only allows a certain amount of access per user. You can do more in \(timeDifferenceInSeconds) seconds", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel) { (_) in }
        
        alertController.addAction(dismissAction)
        view.present(alertController, animated: true)
    }
    
    static func presentBadCredantialsAlertController(view: UIViewController) {
        let launchScreenStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let luanchScreenNav = launchScreenStoryboard.instantiateViewController(withIdentifier: "launchScreenViewController")
        
        let alertController = UIAlertController(title: "No account access", message: "Your authorization credentials were not accepted. You will need to log in again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Log In", style: .default) { (_) in
            view.present(luanchScreenNav, animated: true, completion: nil)
            
        }
        
        alertController.addAction(okAction)
        view.present(alertController, animated: true)
    }
}
