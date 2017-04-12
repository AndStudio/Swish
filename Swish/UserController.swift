//
//  UserController.swift
//  Swish
//
//  Created by Clay Mills on 4/10/17.
//  Copyright © 2017 And. All rights reserved.
//

//URL
// https://api.dribbble.com/v1/users/

//Client Access Token
//70a3dded364357c7f618fd1eb28241ac19511cd0f2110ed34b8508d7e3217184

// create baseURL, create func with @escaping completion, cal the NetworkController, unwrap the base url, append the url, unwrap the data and error, turn data into jsonDictionary, call the images and unwrap


import Foundation

class UserController {
    
    static let baseURL = URL(string: "https://dribbble.com/v1/users/1/shots")
    
    static func fetchUser(for searchTerm: String, completion: @escaping(User?) -> Void) {
        guard let unwrappedURL = baseURL else {completion(nil); return }
        
        let url = unwrappedURL.appendingPathComponent(searchTerm)
        
        NetworkController.performRequest(for: url, httpMethod: .Get) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else {completion(nil)
                return}
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any] else { completion(nil)
                return}
        }
        _ = ["access_token":accessToken]
    }
}
