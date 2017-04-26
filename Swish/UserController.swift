//
//  UserController.swift
//  Swish
//
//  Created by Clay Mills on 4/10/17.
//  Copyright © 2017 And. All rights reserved.
//

import Foundation

class UserController {
    
    static let shared = UserController()
    
    static let baseURL = URL(string: "https://api.dribbble.com/v1/users/1/shots?")
    
    static func fetchAuthenticatedUser(completion: @escaping (User?) -> Void ) {
        guard
            let accessToken = Keychain.value(forKey: "accessToken"),
            let baseURL = URL(string: "https://api.dribbble.com/v1/user?")
            else { return }
        
        let urlComponents: [String:String] = ["access_token":accessToken]
        
        NetworkController.performRequest(for: baseURL, httpMethod: .Get, urlParameters: urlComponents, body: nil) { (data, response, error) in
            if error != nil {
                NSLog("There was an error with your request for function \(#function): \(String(describing: error?.localizedDescription))")
            }
            
            guard
                let data = data,
                let jsonUserDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any],
                let response = response
                else {
                    completion(nil)
                    return }
                        
            if jsonUserDictionary["message"] as? String == "Bad credentials." {
                let message = jsonUserDictionary["message"] as? String
                NSLog(message ?? "Credentials were bad")
                _ = Keychain.removeValue(forKey: "accessToken")
                NotificationCenter.default.post(name: presentBadCredentialsAlertControllerNotification, object: self)
                completion(nil)
            } else if jsonUserDictionary["message"] as? String == "API rate limit exceeded." {
                NotificationCenter.default.post(name: presentAPIAlertControllerNotification, object: self)
            } else if jsonUserDictionary["message"] != nil {
                guard let message = jsonUserDictionary["message"] as? String else { completion(nil); return }
                NSLog(message)
                completion(nil)
            } else {
                let authenticatedUser = User(dictionary: jsonUserDictionary)
                NSLog("The authenticated user has been instantiated")
                completion(authenticatedUser)
            }
        }
    }
}
