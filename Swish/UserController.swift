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
    
    static var currentUser: User?
    
    // FIXME: This is never called, do we need it?
    //    static func loadUserWith(completion: @escaping ([User]) -> Void) {
    //        guard let url = baseURL else { completion([])
    //            return}
    //        let urlParameter = ["username" : Keychain.value(forKey: "accessToken")] as? [String:String]
    //
    //        NetworkController.performRequest(for: url, httpMethod: .Get, urlParameters: urlParameter, body: nil) { (data, error) in
    //
    //            if let error = error {
    //                print(error.localizedDescription)
    //                completion([])
    //                return
    //            }
    //
    //            guard let data = data,
    //                let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
    //                completion([])
    //                return}
    //
    //            let users = jsonDictionary.flatMap({User(dictionary: $0) })
    //
    //
    //            guard let userDictionaries = jsonDictionary?["users"] as? [[String:Any]] else {completion([])
    //                return}
    //
    //        }
    //    }
    
    static func fetchAuthenticatedUser(completion: @escaping (User?) -> Void ) {
        guard
            let accessToken = Keychain.value(forKey: "accessToken"),
            let baseURL = URL(string: "https://api.dribbble.com/v1/user?")
            else { return }
        
        let urlComponents: [String:String] = ["access_token":accessToken]
        
        NetworkController.performRequest(for: baseURL, httpMethod: .Get, urlParameters: urlComponents, body: nil) { (data, error) in
            if error != nil {
                NSLog("There was an error with your request for function \(#function): \(String(describing: error?.localizedDescription))")
            }
            
            guard
                let data = data,
                let jsonUserDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any]
                else { completion(nil); return }
            
            if jsonUserDictionary["message"] != nil {
                _ = Keychain.removeValue(forKey: "accessToken")
                completion(nil)
            } else {
                let authenticatedUser = User(dictionary: jsonUserDictionary)
                completion(authenticatedUser)
            }
        }
    }
    
    
}



