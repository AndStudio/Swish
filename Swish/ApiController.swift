//
//  ApiController.swift
//  Swish
//
//  Created by Taylor Phillips on 4/12/17.
//  Copyright © 2017 And. All rights reserved.
//

import Foundation
class ApiController {
    
    static let accessToken = "70a3dded364357c7f618fd1eb28241ac19511cd0f2110ed34b8508d7e3217184"
//    static let accessToken = NetworkController.accessToken
    static let baseURL = URL(string: "https://api.dribbble.com/v1/shots/")
    
    static func loadShots(completion: @escaping (([Shot]) -> Void)) {
        guard let url = baseURL else { return }
        let urlParameters = ["access_token" : accessToken, "page" : "1", "per_page": "100"]
        
        NetworkController.performRequest(for: url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
            if let error = error {
                NSLog("ERROR: NetworkController.ApiController\(error.localizedDescription)")
                completion([])
                return
            }
            guard let data = data,
                let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                let shot = Shot(dictionary: dictionary),
                let shotsArray = dictionary["shots"] as? [[String: Any]]
                
                else { completion([]); return }
            
            
            let shots = shotsArray.flatMap({ Shot(dictionary: $0) })
            
            ImageController.image(forURL: shot.normalImageURL, completion: { (image) in
                shot.normalImage = image
                
            })
            ImageController.image(forURL: shot.teaserImageURL, completion: { (image) in
                shot.teaserImage = image
            })
            DispatchQueue.main.async {
                completion(shots)
            }
        }
    }

}
