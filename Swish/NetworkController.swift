//
//  NetworkController.swift
//  Swish
//
//  Created by Work on 4/11/17.
//  Copyright © 2017 And. All rights reserved.
//

import Foundation

class NetworkController {
    
    // MARK: Properties
    static var accessToken: String? = Keychain.value(forKey: "accessKey")
    
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    static func performRequest(for url: URL,
                               httpMethod: HTTPMethod,
                               urlParameters: [String : String]? = nil,
                               body: Data? = nil,
                               completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        
        // Build our entire URL
        
        let requestURL = self.url(byAdding: urlParameters, to: url)
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        // Create and "resume" (a.k.a. run) the task
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let response = response else { return }
            DribbleApi.updateAPIHeaderResponses(headerDictionary: response)
            NSLog("API Reset Date: \(String(describing: DribbleApi.apiResetDate))")
            NSLog("API Limit: \(DribbleApi.apiCurrentLimit)")
            
            completion?(data, response, error)
        }
        
        dataTask.resume()
    }
    
    static func url(byAdding parameters: [String : String]?,
                    to url: URL) -> URL {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.flatMap({ URLQueryItem(name: $0.0, value: $0.1) })
        
        guard let url = components?.url else {
            fatalError("URL optional is nil")
        }
        return url
    }
}
