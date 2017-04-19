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
    
    static let accessToken = "70a3dded364357c7f618fd1eb28241ac19511cd0f2110ed34b8508d7e3217184"
    //    static let accessToken = NetworkController.accessToken
    
    static let baseURL = URL(string: "https://api.dribbble.com/v1/shots/")
    
    static func loadShots(completion: @escaping (([Shot]) -> Void)) {
        guard let url = baseURL  else { return }

        let urlParameters = ["access_token" : accessToken, "page" : "1", "per_page": "10"]
        
        NetworkController.performRequest(for: url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
            if let error = error {
                NSLog("ERROR: NetworkController.ApiController\(error.localizedDescription)")
                completion([])
                return
            }
            guard let data = data,
                let shotsDictionaryArray = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [[String: Any]]
                
                else { completion([]); return }
            
            let shots = shotsDictionaryArray.flatMap({ Shot(dictionary: $0) })
            
            let group = DispatchGroup()
            
            for shot in shots {
                group.enter()
                group.enter()
                if shot.hiDpiImageURL == nil {
                    
                    ImageController.image(forURL: shot.normalImageURL, completion: { (image) in
                        shot.largeImage = image
                        group.leave()
                    })
                } else {
                    guard let hiDpiImageURL = shot.hiDpiImageURL else { group.leave(); return }
                    ImageController.image(forURL: hiDpiImageURL, completion: { (image) in
                        shot.largeImage = image
                        group.leave()
                    })
                }
                
                ImageController.image(forURL: shot.teaserImageURL, completion: { (image) in
                    shot.teaserImage = image
                    group.leave()
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                completion(shots)
            })
        }
    }
    
    // MARK: Fetch current users liked shots
    static func fetchLikedShots(page: String, completion: @escaping ([Shot]) -> Void) {
        // Example endpoint: https://api.dribbble.com/v1/user/likes?access_token=a1590f48ee53ae2d172f3c49a444ce3d658e92cf7c95a91cc39eebbd4c5197cd&per_page=20
        
        guard let likesBaseURL = URL(string: "https://api.dribbble.com/v1/user/likes") else { return }
        let urlParameters = ["access_token": NetworkController.accessToken,
                             "per_page":"20",
                             "page":page] as? [String:String]
        
        NetworkController.performRequest(for: likesBaseURL, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
            if error != nil {
                NSLog("There was an error with the API to grab the user's liked shots: \(String(describing: error?.localizedDescription))")
            }
            
            guard let data = data else { completion([]); return }
            
            guard let likedShotsDictionariesArray = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [[String:Any]] else { completion([]); return }
            let likedShotsArray = likedShotsDictionariesArray.flatMap({ Shot(likeDictionary: $0) })
            
            completion(likedShotsArray)
            
        }
    }
    
    //MARK: - Like a shot
    /*
     Liking a shot requires the user to be authenticated to write.
     -parameter shotID: id of the shot to be liked
     -parameter completionHandler: return and error, JSON, NSURLREsponse, status code of the response and a Bool indicating whether the attempt was successful or not.
     */
    
    func fetchTeaserImage(forShot shot: Shot, completion: @escaping (UIImage?) -> Void) {
        let teaserImageURL = shot.teaserImageURL
        ImageController.image(forURL: teaserImageURL) { (image) in
            shot.teaserImage = image
            completion(shot.teaserImage)
        }
    }
    
    static func like(shotId: String, completion: @escaping (_ success: Bool) -> Void) {
        
        let baseURL = "https://api.dribbble.com/v1"
        
        guard let likeURL = URL(string: "\(baseURL)/shots/\(shotId)/like") else { return }
        
        let urlParameters = ["access_token": NetworkController.accessToken] as? [String: String]
        
        var success = false
        
        NetworkController.performRequest(for: likeURL, httpMethod: .Post, urlParameters: urlParameters, body: nil) { (data, error) in
            
            guard let data = data, let responseDataString = String(data: data, encoding: .utf8) else { return }
            
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
    
    //MARK: - Check if shot liked
    
    static func checkIfShotliked(shotId: String, completion: @escaping (_ liked: Bool) -> Void) {
        
        let baseURL = "https://api.dribbble.com/v1"
        
        guard let likesURL = URL(string: "\(baseURL)/shots/\(shotId)/like") else { return }
        
        let urlParameters = ["access_token": NetworkController.accessToken] as? [String: String]
        
        NetworkController.performRequest(for: likesURL, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
            
            if let error = error {
                NSLog("there was a problem checking if the user has liked this shot: \(error.localizedDescription)")
            }
            
            guard let data = data else { return }
            
        }
    }
    
}
