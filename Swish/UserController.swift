//
//  UserController.swift
//  Swish
//
//  Created by Clay Mills on 4/10/17.
//  Copyright © 2017 And. All rights reserved.
//

 // access_token=a1590f48ee53ae2d172f3c49a444ce3d658e92cf7c95a91cc39eebbd4c5197cd




import Foundation

class UserController {
    
    static let shared = UserController()
    
    static let accessToken = "a1590f48ee53ae2d172f3c49a444ce3d658e92cf7c95a91cc39eebbd4c5197cd"
    
    static let baseURL = URL(string: "https://api.dribbble.com/v1/users/1/shots?")
    
    static func loadUserWith(completion: @escaping ([User]) -> Void) {
        guard let url = baseURL else { completion([])
            return}
        let urlParameter = ["username" : accessToken]
        
        NetworkController.performRequest(for: url, httpMethod: .Get, urlParameters: urlParameter, body: nil) { (data, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion([])
                return
            }
            
            guard let data = data,
                let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                completion([])
                return}
            
            let users = jsonDictionary.flatMap({User(dictionary: $0) })
            
            
            guard let userDictionaries = jsonDictionary?["users"] as? [[String:Any]] else {completion([])
                return}
            
        }
    }
    
}



