//
//  UserController.swift
//  Swish
//
//  Created by Clay Mills on 4/10/17.
//  Copyright © 2017 And. All rights reserved.
//

//URL
// https://api.dribbble.com/v1/users/

//Client ID
//e97282047496bac5ee671f3dd82e7e44789a3a011f10d1c8ba375aab4f93097f

//Client Secret
//58770dac962283bdbd486ae4815d087654731bec8d3753a9e332c3069ebd5e8d

//Client Access Token
//70a3dded364357c7f618fd1eb28241ac19511cd0f2110ed34b8508d7e3217184


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
