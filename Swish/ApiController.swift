//
//  ApiController.swift
//  Swish
//
//  Created by Taylor Phillips on 4/12/17.
//  Copyright © 2017 And. All rights reserved.
//

import Foundation
import UIKit

class ApiController {
    
    static let baseURL = URL(string: "https://api.dribbble.com/v1/shots/")
    
    static func loadShots(page: Int, completion: @escaping (([Shot]) -> Void)) {
        guard let url = baseURL  else { return }

        let urlParameters = ["access_token" : DribbleApi.clientAccessKey, "page" : String(page), "per_page": String(DribbleApi.swipeShotsToLoad)]
        
        NetworkController.performRequest(for: url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, response, error) in
            if let error = error {
                NSLog("ERROR: NetworkController.PerformRequest\(error.localizedDescription)")
                completion([])
                return
            }
            guard let data = data,
                let shotsDictionaryArray = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [[String: Any]],
                let response = response
                else { completion([]); return }
            
            let shots = shotsDictionaryArray.flatMap({ Shot(dictionary: $0) })
            let group = DispatchGroup()
            
            DribbleApi.updateAPIHeaderResponses(headerDictionary: response)
            
            group.notify(queue: DispatchQueue.main, execute: {
                completion(shots)
            })
        }
    }
    
    // MARK: Fetch current users liked shots
    static func fetchLikedShots(page: String, completion: @escaping ([Shot]) -> Void) {
        // Example endpoint: https://api.dribbble.com/v1/user/likes?access_token=a1590f48ee53ae2d172f3c49a444ce3d658e92cf7c95a91cc39eebbd4c5197cd&per_page=20
        
        guard let likesBaseURL = URL(string: "https://api.dribbble.com/v1/user/likes") else { return }
        let urlParameters = ["access_token": Keychain.value(forKey: "accessToken"),
                             "per_page":String(DribbleApi.collectionShotsToLoad),
                             "page":page] as? [String:String]
        
        NetworkController.performRequest(for: likesBaseURL, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, response, error) in
            if error != nil {
                NSLog("There was an error with the API to grab the user's liked shots: \(String(describing: error?.localizedDescription))")
            }
            
            var likedShotsArray: [Shot] = []
            
            guard let data = data, let response = response else { completion([]); return }
            
            if let likedShotsDictionariesArray = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [[String:Any]] {
                likedShotsArray = likedShotsDictionariesArray.flatMap({ Shot(likeDictionary: $0) })
            } else if let messageDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any] {
                if messageDictionary["message"] as? String == "Bad credentials." {
                    NotificationCenter.default.post(name: presentBadCredentialsAlertControllerNotification, object: self)
                } else if messageDictionary["message"] as? String == "API rate limit exceeded." {
                    NotificationCenter.default.post(name: presentAPIAlertControllerNotification, object: self)
                }
            }
            
            DribbleApi.updateAPIHeaderResponses(headerDictionary: response)
            
            completion(likedShotsArray)
            
        }
    }
    
    static func fetchAuthenticatedUsersLikedShots(completion: @escaping ([Shot]) -> Void) {
        
        guard let currentUser = DribbleApi.currentUser else { return }
        
        var shotsArray: [Shot] = []
        var page = 1
        let maxPage: Int = Int(ceil(Double(currentUser.likeCount) / Double(DribbleApi.collectionShotsToLoad)))
        
        while page <= maxPage {
            page += 1
            ApiController.fetchLikedShots(page: String(page), completion: { (shots) in
                shotsArray.append(contentsOf:shots)
                print(page)
                
            })
        }
        completion(shotsArray)
    }
    
    static func fetchShots(forUser user: User, page: String, completion: @escaping ([Shot]) -> Void) {
        // Example enpoint: https://api.dribbble.com/v1/users/dribbble/shots?access_token=a1590f48ee53ae2d172f3c49a444ce3d658e92cf7c95a91cc39eebbd4c5197cd&per_page=20
        
        guard let likesBaseURL = URL(string: "https://api.dribbble.com/v1/users/\(user.userUserName)/shots") else { return }
        
        let urlParameters = ["access_token": DribbleApi.clientAccessKey,
                             "per_page":String(DribbleApi.collectionShotsToLoad),
                             "page":page]
        
        NetworkController.performRequest(for: likesBaseURL, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, response, error) in
            if error != nil {
                NSLog("There was an error with the API to grab the user's liked shots: \(String(describing: error?.localizedDescription))")
            }
            
            guard
                let data = data,
                let response = response,
                let shotsDictionariesArray = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [[String:Any]]
                else { completion([]); return }
            
            let likedShotsArray = shotsDictionariesArray.flatMap({ Shot(dictionary: $0) })
            
            DribbleApi.updateAPIHeaderResponses(headerDictionary: response)
            
            completion(likedShotsArray)
            
        }

    }
    
    func fetchTeaserImage(forShot shot: Shot, completion: @escaping (UIImage?) -> Void) {
        let teaserImageURL = shot.teaserImageURL
        ImageController.image(forURL: teaserImageURL) { (image) in
            shot.teaserImage = image
            completion(image)
        }
    }
    
    static func like(shotId: String, completion: @escaping (_ success: Bool) -> Void) {
        
        let baseURL = "https://api.dribbble.com/v1"
        
        guard let likeURL = URL(string: "\(baseURL)/shots/\(shotId)/like") else { return }
        
        let urlParameters = ["access_token": Keychain.value(forKey: "accessToken")] as? [String: String]
        
        var success = false
        
        NetworkController.performRequest(for: likeURL, httpMethod: .Post, urlParameters: urlParameters, body: nil) { (data, response, error) in
            
            guard
                let data = data,
                let responseDataString = String(data: data, encoding: .utf8),
                let response = response
                else { return }
            
            DribbleApi.updateAPIHeaderResponses(headerDictionary: response)
            
            if let error = error {
                NSLog("there was a problem with the API trying to like a shot: \(error.localizedDescription)")
            } else if responseDataString.contains("error") {
                print("Error: \n\(responseDataString)")
            } else {
                print("Successfully liked shot \(shotId)")
                success = true
            }
            
            completion(success)
        }
    }
}
